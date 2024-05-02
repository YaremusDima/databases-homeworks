local vshard = require('vshard')

function add_money(id, money, cost_per_second)
    local bucket_id = vshard.router.bucket_id_mpcrc32({ id })
    return vshard.router.callrw(bucket_id, 'add_money', { id, money, cost_per_second })
end

function set_money_speed(user_id, cost)
    local bucket_id = vshard.router.bucket_id_mpcrc32({ user_id })
    return vshard.router.callrw(bucket_id, 'set_money_speed', { user_id, cost })
end

function get_balance(id)
    local bucket_id = vshard.router.bucket_id_mpcrc32({ id })
    return vshard.router.callro(bucket_id, 'get_balance', { id })
end
