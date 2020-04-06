box.cfg {
    listen = 3302;
    slab_alloc_arena = 0.1;
}

local function bootstrap2()
    local space = box.schema.create_space('example-with-auth')
    space:create_index('primary')
    box.schema.user.create('test', { password = 'qwerty321' })
    box.schema.user.grant('test', 'read,write,execute', 'universe')
end

box.once('example-with-auth', bootstrap2)
