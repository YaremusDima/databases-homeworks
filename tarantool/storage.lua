fiber = require('fiber')
math = require('math')
expirationd = require('expirationd')
box.schema.create_space('bank', {
    format = {
        { name = 'user_id', type = 'unsigned' },
        { name = 'money', type = 'unsigned' },
        { name = 'time', type = 'unsigned' },
        { name = 'cost_per_second', type = 'unsigned'}
    },
    if_not_exists = true
})

box.space.bank:create_index('user_id', { parts = { 'user_id' }, if_not_exists = true })
box.space.bank:create_index('money_left', { parts = { 'time' }, unique = false, if_not_exists = true })

function add_money(id, money, cost_per_second)
    local t = box.space.bank:get(id)
    if t == nil then
        if cost_per_second == nil then
            return false
        end
        box.space.bank:insert({ id, money, math.floor(fiber.time()), cost_per_second})
        return true
    end
    local losted = t.cost_per_second * (math.floor(fiber.time()) - t.time)
    if losted >= t.money then
        box.space.bank:replace({ id, money, math.floor(fiber.time()), t.cost_per_second})
    else
        box.space.bank:replace({ id, money + t.money - losted, math.floor(fiber.time()), t.cost_per_second})
    end
    return true
end

function set_money_speed(user_id, cost)
    local t = box.space.bank:get(user_id)
    if t == nil or cost == nil then
        return false
    end
    local losted = t.cost_per_second * (math.floor(fiber.time()) - t.time)
    if losted >= t.money then
        box.space.bank:replace({ user_id, 0, math.floor(fiber.time()), cost})
    else
        box.space.bank:replace({ user_id, t.money - losted, math.floor(fiber.time()), cost})
    end
    return true
end

function get_balance(id)
    local tuple = box.space.bank:get(id)
    if tuple == nil then
        return nil
    end
    return { tuple.user_id, tuple.money, tuple.time, tuple.cost_per_second, tuple.money - (fiber.time() - tuple.time) * tuple.cost_per_second}
end

function is_expired(args, tuple)
    if tuple.cost_per_second * (math.floor(fiber.time()) - tuple.time) >= tuple.money then
        return true
    end
    return false
end

function delete_tuple(space, args, tuple)
    local http_client = require('http.client').new()
    local user = tuple[2]
    box.space[space]:delete{tuple[1]}
    http_client.request('GET', 'https://postavte_otl.org/get/off/' .. tostring(user.user_id))
end

expirationd.start("clean_tuples", box.space.bank.id, is_expired, {
    process_expired_tuple = delete_tuple,
    args = nil,
    tuples_per_iteration = 50,
    full_scan_time = 3600
})