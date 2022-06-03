create database store;
use store;

create table items (
  id int not null auto_increment,
  name varchar(255) not null,
  description varchar(255) not null,
  price int not null,
  primary key (id)
);

insert into items (name, description, price) values ("bees", "A packet of bees.", 3);
insert into items (name, description, price) values ("trees", "Some trees.", 3);
insert into items (name, description, price) values ("wheels", "Four wheels.", 3);
insert into items (name, description, price) values ("flowers", "Not actually flowers, but seeds.", 3);
insert into items (name, description, price) values ("rocks", "A pile o' stones.", 3);
insert into items (name, description, price) values ("orange soda", "Several bottles of orange soda.", 3);
