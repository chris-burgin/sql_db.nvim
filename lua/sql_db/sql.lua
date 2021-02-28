local util = require('nvim_sql/util')

local nvim_sql = {}
nvim_sql.opts = {}

function nvim_sql.run_query(query)
	local lines = {};

	util.run_job({
		command = 'mysql',
		args = {
			'--table',
			'-u',
			'root',
			'-h',
			nvim_sql.opts.db.host,
			'-e',
			query,
			nvim_sql.opts.db.database,
		},
		on_stdout = vim.schedule_wrap(function (_, line)
			table.insert(lines, line)
		end),
		on_stderr = function (_, data)
			table.insert(lines, data)
		end,
		on_exit = vim.schedule_wrap(function()
			util.create_query_result_buf(lines)
		end),
	})
end

function nvim_sql.run_query_on_selection()
	local query = util.get_query(nvim_sql.opts);
	nvim_sql.run_query(query)
end;

function nvim_sql.run_query_on_selection_r(args)
	local replacements = util.split_on_space(args)
	local query = util.get_query(nvim_sql.opts);

	for _, replacement in ipairs(replacements) do
		query = query:gsub("?", replacement)
	end

	nvim_sql.run_query(query)
end;

function nvim_sql.setup(opts)
	if opts == nil then
		error("opts where not provided to nvim_sql.setup")
	end

	if opts.query_buf == nil then
		opts.query_buf = "="
	end

	if opts.db == nil then
		error("opts.db was not provided to nvim_sql.setup")
	end

	if opts.db.host == nil then
		error("opts.db.host was not provided to nvim_sql.setup")
	end

	if opts.db.database == nil then
		error("opts.db.database was not provided to nvim_sql.setup")
	end

	nvim_sql.opts = opts;
end

return nvim_sql
