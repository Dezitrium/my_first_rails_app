# module Constants
  VALID_EMAILS = %w(test@test.de TEST@TEST.de user@foo.COM user_name@foo.COM 
    A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)

  INVALID_EMAILS = %w(test test@test@de user@foo,com user_at_foo.org
    example.user@foo. foo@bar_baz.com foo@bar+baz.com)
# end