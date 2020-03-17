Neovim.plugin do |plug|
  plug.command(:HsSortImports) do |client|
    # Locate and parse block of import statements
    first_i = nil
    last_i = nil
    imports = []
    client.current.buffer.lines.each_with_index do |line, i|
      if line =~ /^import\s+(qualified\s)?\s*(\S+)\s*(.+?)?\s*$/
        first_i ||= i
        last_i = i
        imports << $~.captures.map { |c| c || '' }
      elsif imports.any? && line.match?(/\S/)
        break
      end
    end

    # Leave early if no import statements
    next if imports.none?

    # Sort
    imports.sort_by! { |qualified, module_name, _| [module_name, qualified] }

    # Render columns
    qualified_width = imports.lazy.map do |qualified, _, _|
      qualified.length
    end.max
    module_name_width = imports.lazy.map do |_, module_name, _|
      module_name.length
    end.max
    fmt = "import %-#{qualified_width}s%-#{module_name_width}s %s"
    imports.map! { |captures| (fmt % captures).strip }

    # Set
    client.current.buffer.set_lines first_i, last_i + 1, true, imports
  end
end
