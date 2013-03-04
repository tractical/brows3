module ResourcesHelper

  # Populate Tree to avoid calls to AWS
  def tree_from_bucket(bucket)
    unless defined? @@tree
      @tree = Tree::TreeNode.new(bucket.key) # Root node

      bucket.files.each do |file|
        splitted_key = file.key.split('/')
        name = splitted_key.last

        if splitted_key.size >= 2
          parent = @tree.find { |node| node.name == splitted_key[-2] }
          parent.add(Tree::TreeNode.new(name, file))
        else
          @tree.add(Tree::TreeNode.new(name, file))
        end
      end
    end

    @tree
  end

end