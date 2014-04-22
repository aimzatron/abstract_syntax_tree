require './main'
  describe TreeNode do
    let(:op_node){ TreeNode.new('+') }
    let(:left_node){ TreeNode.new(1) }
    let(:right_node){ TreeNode.new('2') }
    let(:changed_node){ TreeNode.new(3) }

    before do
      op_node.right = right_node
      op_node.left = left_node
    end

    it "is a tree" do
      expect(TreeNode.new('1')).to be_true
    end

    it "stores operators" do
      expect(op_node.content).to eq '+'
    end

    it "stores numbers" do
      expect(left_node.content).to eq 1.0
      expect(right_node.content).to eq 2.0
    end

    it "converts numbers to floats when not an operator" do
      expect(changed_node.content).to eq 3.0

      changed_node.content = '4'
      expect(changed_node.content).to eq 4.0
    end

    it "stores a right tree" do
      op_node.right = right_node
      expect(op_node.right).to eq right_node
    end

    it "stores a left tree" do
      op_node.left = left_node
      expect(op_node.left).to eq left_node
    end

    it "executes the math" do
      expect(op_node.execute).to eq 3.0
    end

    it "knows if it's a leaf" do
      expect(left_node.leaf?).to be_true
    end

    it "executes more complex math" do
      complex_root = TreeNode.new('-')
      complex_root.left = TreeNode.new(10)
      complex_root.right = op_node
      expect(complex_root.execute).to eq 7.0
    end

    describe '.parse' do

      it "parses simple mathematical expressions into a tree" do
        simple_node_starter = TreeNode.new('1 + 2')
        simple_node = simple_node_starter.parse('1 + 2')

        expect(simple_node.content).to eq '+'
        expect(simple_node.left.content).to eq 1.0
        expect(simple_node.right.content).to eq 2.0
      end

      it "parses complex math expressions into a tree" do
        complex_node_starter = TreeNode.new('10 - (1 * 2)')
        complex_node = complex_node_starter.parse('10 - (1 * 2)')

        expect(complex_node.content).to eq '-'
        expect(complex_node.left.content).to eq 10.0

        expect(complex_node.right.content).to eq '*'
        expect(complex_node.right.right.content).to eq 2.0
        expect(complex_node.right.left.content).to eq 1.0
        expect(complex_node.execute).to eq 8.0
      end
    end

  end
