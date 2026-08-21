return {
	{
		"janko/vim-test",
		keys = {
			{ "<leader>tr", "<cmd>TestLast<CR>", desc = "Test: Last" },
			{ "<leader>ts", "<cmd>TestNearest<CR>", desc = "Test: Nearest" },
			{
				"<leader>tS",
				function()
					vim.fn.setenv("WATCH", "1")
					vim.cmd("TestNearest")
					vim.fn.setenv("WATCH", nil)
				end,
				desc = "Test: Nearest (watch)",
			},
			{ "<leader>tt", "<cmd>TestFile<CR>", desc = "Test: File" },
		},
		init = function()
			vim.g["test#strategy"] = "neovim"

			-- ruby
			-- local ruby_formatter = vim.fn.expand("~/.config/nvim/support/vim_formatter.rb")
			local opts = {
				-- "--no-color",
				-- "--require " .. vim.fn.shellescape(ruby_formatter),
				-- "--format VimFormatter",
			}
			vim.g["test#ruby#rspec#options"] = table.concat(opts, " ")

			vim.g["test#ruby#minitest#file_pattern"] = "_test\\.rb$"
			vim.g["test#ruby#minitest#env"] = { RUBYOPT = "-rminitest/pride" }
			vim.g["test#ruby#minitest#executable"] = "ruby"
			vim.g["test#ruby#minitest#options"] = ""

			vim.g["test#javascript#runner"] = "jest"
			vim.g["test#javascript#jest#executable"] = "node --test"

			vim.cmd([[
				function! NodeTestTransform(cmd) abort
					let cmd = substitute(a:cmd, '--runTestsByPath\s*', '', '')
					let cmd = substitute(cmd, '--testNamePattern', '--test-name-pattern', '')
					let cmd = substitute(cmd, ' -t ', ' --test-name-pattern ', '')
					return cmd
				endfunction
				let g:test#custom_transformations = { 'nodetest': function('NodeTestTransform') }
				let g:test#transformation = 'nodetest'
			]])

			vim.g["test#python#pytest#executable"] = "pytest"
			vim.g["test#python#pytest#options"] = "-s --color=no"
		end,
	},
	{
		"tpope/vim-projectionist",
		lazy = false,
		init = function()
			vim.g.projectionist_heuristics = {
				-- Ruby minitest (same directory, e.g. exercism)
				["*_test.rb"] = {
					["*_test.rb"] = {
						alternate = "{}.rb",
						type = "test",
						dispatch = "ruby {file}",
					},
					["*.rb"] = {
						alternate = "{}_test.rb",
						type = "source",
					},
				},
				-- Ruby projects (non-Rails; vim-rails handles standard Rails paths)
				["Gemfile&!config/environment.rb"] = {
					["lib/*.rb"] = {
						alternate = "spec/{}_spec.rb",
						type = "source",
					},
					["spec/*_spec.rb"] = {
						alternate = "lib/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["test/*_test.rb"] = {
						alternate = "lib/{}.rb",
						type = "test",
						dispatch = "bundle exec ruby -Itest {file}",
					},
				},

				-- Rails extensions (services, policies, etc. that vim-rails doesn't cover)
				["config/environment.rb"] = {
					["app/services/*.rb"] = {
						alternate = "spec/services/{}_spec.rb",
						type = "service",
					},
					["spec/services/*_spec.rb"] = {
						alternate = "app/services/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/policies/*.rb"] = {
						alternate = "spec/policies/{}_spec.rb",
						type = "policy",
					},
					["spec/policies/*_spec.rb"] = {
						alternate = "app/policies/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/components/*.rb"] = {
						alternate = "spec/components/{}_spec.rb",
						type = "component",
					},
					["spec/components/*_spec.rb"] = {
						alternate = "app/components/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/wizards/*.rb"] = {
						alternate = "spec/wizards/{}_spec.rb",
						type = "wizard",
					},
					["spec/wizards/*_spec.rb"] = {
						alternate = "app/wizards/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/lib/*.rb"] = {
						alternate = "spec/lib/{}_spec.rb",
						type = "lib",
					},
					["spec/lib/*_spec.rb"] = {
						alternate = "app/lib/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/helpers/*.rb"] = {
						alternate = "spec/helpers/{}_spec.rb",
						type = "helper",
					},
					["spec/helpers/*_spec.rb"] = {
						alternate = "app/helpers/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/queries/*.rb"] = {
						alternate = "spec/queries/{}_spec.rb",
						type = "query",
					},
					["spec/queries/*_spec.rb"] = {
						alternate = "app/queries/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/decorators/*.rb"] = {
						alternate = "spec/decorators/{}_spec.rb",
						type = "decorator",
					},
					["spec/decorators/*_spec.rb"] = {
						alternate = "app/decorators/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/forms/*.rb"] = {
						alternate = "spec/forms/{}_spec.rb",
						type = "form",
					},
					["spec/forms/*_spec.rb"] = {
						alternate = "app/forms/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/workers/*.rb"] = {
						alternate = "spec/workers/{}_spec.rb",
						type = "worker",
					},
					["spec/workers/*_spec.rb"] = {
						alternate = "app/workers/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
					["app/jobs/*.rb"] = {
						alternate = "spec/jobs/{}_spec.rb",
						type = "job",
					},
					["spec/jobs/*_spec.rb"] = {
						alternate = "app/jobs/{}.rb",
						type = "spec",
						dispatch = "bundle exec rspec {file}",
					},
				},
				-- Python projects (NEW)
				["pyproject.toml"] = {
					["*.py"] = {
						alternate = "tests/test_{}.py",
						type = "source",
						except = "setup.py",
					},
					["tests/test_*.py"] = {
						alternate = "{}.py",
						type = "test",
						dispatch = "pytest {file}",
					},
					["{package}/*.py"] = {
						alternate = "tests/{package}/test_{}.py",
						type = "source",
					},
					["tests/{package}/test_*.py"] = {
						alternate = "{package}/{}.py",
						type = "test",
						dispatch = "pytest {file}",
					},
				},
				-- TypeScript projects
				["tsconfig.json"] = {
					["src/*.ts"] = {
						alternate = { "src/{}.test.ts", "src/{}.spec.ts" },
						type = "source",
					},
					["src/*.test.ts"] = {
						alternate = "src/{}.ts",
						type = "test",
						dispatch = "npx vitest run {file}",
					},
					["src/*.spec.ts"] = {
						alternate = "src/{}.ts",
						type = "test",
						dispatch = "npx vitest run {file}",
					},
					["src/*.tsx"] = {
						alternate = { "src/{}.test.tsx", "src/{}.spec.tsx" },
						type = "source",
					},
					["src/*.test.tsx"] = {
						alternate = "src/{}.tsx",
						type = "test",
						dispatch = "npx vitest run {file}",
					},
					["src/*.spec.tsx"] = {
						alternate = "src/{}.tsx",
						type = "test",
						dispatch = "npx vitest run {file}",
					},
				},
				-- JavaScript projects (no tsconfig)
				["package.json&!tsconfig.json"] = {
					["src/*.js"] = {
						alternate = { "src/{}.test.js", "src/{}.spec.js" },
						type = "source",
					},
					["src/*.test.js"] = {
						alternate = "src/{}.js",
						type = "test",
						dispatch = "npx jest {file}",
					},
					["src/*.spec.js"] = {
						alternate = "src/{}.js",
						type = "test",
						dispatch = "npx jest {file}",
					},
				}
			}
		end,
		keys = {
			{ "<leader>ta", "<cmd>AE<CR>", desc = "Alternate File" },
			{ "<leader>tv", "<cmd>AV<CR>", desc = "Alternate (vsplit)" },
			{ "<leader>th", "<cmd>AS<CR>", desc = "Alternate (split)" },
		},
	},
}
