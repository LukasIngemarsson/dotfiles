return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    keys = {
      {
        '<leader>cc',
        function()
          require('CopilotChat').toggle()
        end,
        desc = 'Toggle CopilotChat',
        mode = 'n',
      },
    },
    config = function()
      require('render-markdown').setup {
        file_types = { 'markdown', 'copilot-chat' },
      }
      require('CopilotChat').setup {
        highlight_headers = false,
        separator = '---',
        error_header = '> [!ERROR] Error',
      }
    end,
  },
}
