# Extending AWS::S3 functionality
module AWS
  class S3

    class S3Object

      def as_json
        {
          "key" => key,
          "url_for_read" => url_for(:read)
        }
      end
    end

    class Bucket

      # Represent all BranchNode in an AWS::S3::Tree at a given level (prefix).
      # Branch nodes are often treated like directories.
      # http://docs.amazonwebservices.com/AWSRubySDK/latest/AWS/S3/Tree/BranchNode.html
      #
      def directories(prefix = nil)
        as_tree(prefix: prefix).children.select(&:branch?)
      end

      # Represent all LeafNode in an AWS::S3::Tree at a given level (prefix).
      # LeafNode are often treated as files.
      # http://docs.amazonwebservices.com/AWSRubySDK/latest/AWS/S3/Tree/LeafNode.html
      #
      def files(prefix = nil)
        as_tree(prefix: prefix).children.select(&:leaf?)
      end

      def resources(prefix = nil)
        { directories: directories(prefix), files: files(prefix) }
      end
    end
  end
end