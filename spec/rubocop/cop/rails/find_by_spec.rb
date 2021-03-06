# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::FindBy, :config do
  it 'registers and corrects an offense when using `#take`' do
    expect_offense(<<~RUBY)
      User.where(id: x).take
           ^^^^^^^^^^^^^^^^^ Use `find_by` instead of `where.take`.
    RUBY

    expect_correction(<<~RUBY)
      User.find_by(id: x)
    RUBY
  end

  context 'when using safe navigation operator' do
    it 'registers an offense when using `#take`' do
      expect_offense(<<~RUBY)
        users&.where(id: x).take
               ^^^^^^^^^^^^^^^^^ Use `find_by` instead of `where.take`.
      RUBY

      expect_correction(<<~RUBY)
        users&.find_by(id: x)
      RUBY
    end
  end

  it 'does not register an offense when using find_by' do
    expect_no_offenses('User.find_by(id: x)')
  end

  context 'when `IgnoreWhereFirst: true' do
    let(:cop_config) do
      { 'IgnoreWhereFirst' => true }
    end

    it 'does not register an offense when using `#first`' do
      expect_no_offenses(<<~RUBY)
        User.where(id: x).first
      RUBY
    end
  end

  context 'when `IgnoreWhereFirst: false' do
    let(:cop_config) do
      { 'IgnoreWhereFirst' => false }
    end

    it 'registers an offense when using `#first` and does not auto-correct' do
      expect_offense(<<~RUBY)
        User.where(id: x).first
             ^^^^^^^^^^^^^^^^^^ Use `find_by` instead of `where.first`.
      RUBY

      expect_no_corrections
    end
  end
end
