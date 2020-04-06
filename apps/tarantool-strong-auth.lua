box.cfg {
    listen = 3303;
    slab_alloc_arena = 0.1;
}

local function bootstrap3()
    local space = box.schema.create_space('example-strong-auth')
    space:create_index('primary')
    box.schema.user.create('Administrator', { password = 'Dfjk4fyudhnw#' })
    box.schema.user.grant('Administrator', 'read,write,execute', 'universe')
end

box.once('example-strong-auth', bootstrap3)
