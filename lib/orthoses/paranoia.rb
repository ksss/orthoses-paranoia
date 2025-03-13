# frozen_string_literal: true

require "orthoses"
require_relative "paranoia/version"

module Orthoses
  class Paranoia
    def initialize(loader)
      @loader = loader
    end

    def call
      acts_as_paranoid = CallTracer::Lazy.new
      store = acts_as_paranoid.trace("ActiveRecord::Base.acts_as_paranoid") do
        @loader.call
      end

      acts_as_paranoid.captures.each do |capture|
        base_name = Utils.module_name(capture.method.receiver) or next
        paranoia_class_methods = "#{base_name}::ParanoiaMethods"
        next if store.key?(paranoia_class_methods)

        store[paranoia_class_methods].header = "module #{paranoia_class_methods}"
        store[paranoia_class_methods] << "def with_deleted: () -> #{base_name}::ActiveRecord_Relation"
        store[paranoia_class_methods] << "def only_deleted: () -> #{base_name}::ActiveRecord_Relation"
        store[paranoia_class_methods] << "alias deleted only_deleted"
        store[paranoia_class_methods] << "def paranoia_scope: () -> #{base_name}::ActiveRecord_Relation"
        store[paranoia_class_methods] << "alias without_deleted paranoia_scope"

        store[base_name] << "extend #{paranoia_class_methods}"
        store["#{base_name}::ActiveRecord_Relation"] << "include #{paranoia_class_methods}"
        store["#{base_name}::ActiveRecord_Associations_CollectionProxy"] << "include #{paranoia_class_methods}"
      end

      store
    end
  end
end
