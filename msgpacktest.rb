require 'msgpack'



msg = 'this is my new message'

packed_msg = MessagePack.pack(msg)

new_one = MessagePack.unpack(packed_msg)

save_file = File.open('test.txt', 'w')

puts new_one
