sql = <<-SQL
  INSERT INTO "users" ("id", "username", "created_at", "updated_at", "email", "password_digest", "admin") VALUES (18, 'eh1', '2017-11-14 08:39:33.288949', '2017-11-14 08:39:33.288949', 'eh1@gmail.com', '$2a$10$0ECd6ro3tEr9s0/68joWcujU4fitov/hcNgOe2ym1MZYrDc/LNgYG', 0);
  INSERT INTO "dishes" ("id", "name", "price", "description", "created_at", "updated_at", "image_url") VALUES (42, 'ds', 12.0, '', '2017-10-31 09:02:54.856745', '2017-10-31 09:02:54.856745', '');
SQL
ActiveRecord::Base.transaction do
  ActiveRecord::Base.connection.execute(sql);
end