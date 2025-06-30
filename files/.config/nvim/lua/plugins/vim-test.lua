return {
  "janko/vim-test" ,
  init = function() 
    vim.g['test#custom_strategies'] = {
      pytest_s = function(cmd)
        return cmd .. ' -s'
      end
    }

    vim.g['test#python#pytest#options'] = '-s --color=no'
    vim.cmd("let $TERM = 'xterm-256color'")
    vim.o.shell = '/bin/zsh'
    vim.g['test#python#pytest#executable'] = '~/.zsh/bin/nocolor-pytest'
  end
}
