box.cfg {
    listen = 3301;
    slab_alloc_arena = 0.1;
}

local function bootstrap1()
    local space = box.schema.create_space('example-guest')
    space:create_index('primary')
    box.schema.user.grant('guest', 'read,write,execute', 'universe')
    box.schema.user.create('administrator', { password = 'kjfjksfdf7hdsf' })
    box.schema.user.grant('administrator', 'read,write,execute', 'universe')
end

box.once('example-guest', bootstrap1)
