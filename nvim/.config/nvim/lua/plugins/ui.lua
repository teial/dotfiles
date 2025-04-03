return {
    {
        "echasnovski/mini.indentscope",
        opts = {
            draw = {
                delay = 0,
                animation = require("mini.indentscope").gen_animation.none(),
            },
        },
    },
    {
        "snacks.nvim",
        opts = {
            scroll = {
                animate = {
                    duration = { step = 5, total = 100 },
                    easing = "inOutQuad",
                },
            },
        },
    },
}
