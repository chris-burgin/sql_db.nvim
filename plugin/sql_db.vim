command -nargs=1 SQL call luaeval("require'sql_db.sql'.run_query(_A)", <f-args>)
command -range=% SQL_S lua require'sql_db.sql'.run_query_on_selection()
command -range=% -nargs=1 SQL_SR call luaeval("require'sql_db.sql'.run_query_on_selection_r(_A)", <f-args>)
