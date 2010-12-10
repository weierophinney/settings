if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet getter <CR>/**<CR>Get ".st."protected".et."<CR><CR>@return ".st."type".et."<CR>/<CR>public function get".st."name".et."()<CR>{<CR>    return $this->_".st."protected".et.";<CR>}<CR>"
exec "Snippet setter <CR>/**<CR>Set ".st."protected".et."<CR><CR>@param  ".st."type".et."<CR>@return ".st."class".et."<CR>/<CR>public function set".st."name".et."($value)<CR>{<CR>    $this->_".st."protected".et." = $value;<CR>return $this;<CR>}<CR>"
exec "Snippet accessors <CR>/**<CR>Get ".st."protected".et."<CR><CR>@return ".st."type".et."<CR>/<CR>public function get".st."name".et."()<CR>{<CR>    return $this->_".st."protected".et.";<CR>}<CR><CR>/**<CR>Set ".st."protected".et."<CR><CR>@param  ".st."type".et."<CR>@return ".st."class".et."<CR>/<CR>public function set".st."name".et."($value)<CR>{<CR>    $this->_".st."protected".et." = $value;<CR>return $this;<CR>}<CR>"
