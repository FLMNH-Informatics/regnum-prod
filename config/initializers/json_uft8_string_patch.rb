
class String

  def encode_json(encoder) 
    #patch to pass proper utf8 encoding to JSON encoder
    #encoder.escape(self) 
    #duplicate necessary to alter string though something could
    #be lost from in the copy
    copy = self.dup
    encoder.escape(copy.encode('utf-8'))
  end

end
