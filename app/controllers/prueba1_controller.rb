def my_property
  @instance_options[:VARIABLE]
end

render jsons: @objeto, VARIABLE: "ans",status: 200, serializer: mySerializer   