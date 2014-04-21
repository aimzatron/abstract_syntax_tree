class TreeNode
  attr_accessor :content, :right, :left
  require 'pry'
  OP_PRIORITY = {"+" => 0, "-" => 0, "*" => 1, "/" => 1}
  OPERATORS = ['+', '-', '/','*']

  def initialize(content)
    self.content = content
  end

  def content=(content)
    @content = if OPERATORS.include?(content)
      content
    else
      content.to_f
    end
  end

  def execute
    if self.leaf?
      content
    elsif @right.content == 0.0
      eval("#{@right.left.content} #{@content} #{@right.right.execute}")
    else
      eval("#{@left.execute} #{@content} #{@right.execute}")
    end  
  end

  def leaf?
    right == nil && left == nil
  end

  def parse(formula)
    operator_stack, node_stack = [],[]

    formula_array = formula.gsub(/([\+\-\/\*])/,' \1 ')
                           .gsub(/([\(\)])/,' \1 ')
                           .split(/\s+/)

    formula_array.each do |formula_item|
      if OPERATORS.include? formula_item
        stack_it(operator_stack, node_stack) until operator_stack.empty? ||
                                                    operator_stack.last == '(' ||
                                                    OP_PRIORITY[operator_stack.last.content] == nil ||
                                                    OP_PRIORITY[operator_stack.last.content] < OP_PRIORITY[formula_item]
        operator_stack << TreeNode.new(formula_item)
      elsif formula_item == '('
        operator_stack << TreeNode.new(formula_item)
      elsif formula_item == ')'
        while operator_stack.last != '(' && !operator_stack.empty?
          stack_it(operator_stack, node_stack)
        end
        operator_stack.pop
      else
        node_stack << TreeNode.new(formula_item)
      end
    end

    until operator_stack.empty?
      stack_it(operator_stack,node_stack)
    end

    node_stack.last
  end

  def stack_it(operator_stack, node_stack)
    temp = operator_stack.pop
    temp.right = node_stack.pop
    temp.left = node_stack.pop
    node_stack << temp
  end

end