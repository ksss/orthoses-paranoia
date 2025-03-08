# frozen_string_literal: true

require "test_helper"

module ParanoiaTest
  LOADER = lambda {
    class User < ActiveRecord::Base
      acts_as_paranoid
    end

    class Post < ActiveRecord::Base
    end
  }

  def test_paranoia(t)
    store = Orthoses::Paranoia.new(
      Orthoses::Store.new(LOADER)
    ).call

    actual = store["ParanoiaTest::User"].to_rbs
    expect = <<~RBS
      class ParanoiaTest::User < ::ActiveRecord::Base
        extend ParanoiaTest::User::ParanoiaClassMethods
      end
    RBS
    unless expect == actual
      t.error("expect=\n```rbs\n#{expect}```\n, but got \n```rbs\n#{actual}```\n")
    end

    actual = store["ParanoiaTest::Post"].to_rbs
    expect = <<~RBS
      class ParanoiaTest::Post < ::ActiveRecord::Base
      end
    RBS
    unless expect == actual
      t.error("expect=\n```rbs\n#{expect}```\n, but got \n```rbs\n#{actual}```\n")
    end

    actual = store["ParanoiaTest::User::ParanoiaClassMethods"].to_rbs
    expect = <<~RBS
      module ParanoiaTest::User::ParanoiaClassMethods
        def with_deleted: () -> ParanoiaTest::User::ActiveRecord_Relation

        def only_deleted: () -> ParanoiaTest::User::ActiveRecord_Relation

        alias deleted only_deleted

        def paranoia_scope: () -> ParanoiaTest::User::ActiveRecord_Relation

        alias without_deleted paranoia_scope
      end
    RBS
    unless expect == actual
      t.error("expect=\n```rbs\n#{expect}```\n, but got \n```rbs\n#{actual}```\n")
    end
  end
end
