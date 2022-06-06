create database store;
use store;

create table items (
  id int not null auto_increment,
  name varchar(255) not null,
  description varchar(255) not null,
  price int not null,
  primary key (id)
);

insert into items (name, description, price) values ("Strawberries", "A small strawberry plant.", 5);
insert into items (name, description, price) values ("Spinach Seeds", "A packet of spinach seeds.", 1);
insert into items (name, description, price) values ("Watermelon Seeds", "A packet of watermelon seeds.", 1);
insert into items (name, description, price) values ("Onion Starts", "A package of onion starts used to grow onions.", 5);
insert into items (name, description, price) values ("String of Pearls", "A small string of pearls plant.", 6);
insert into items (name, description, price) values ("Aloe Vera", "A succulent that produces a medicinal gel.", 6);
insert into items (name, description, price) values ("Iresine", "Also known as bloodleaf due to its red leaves.", 14);
insert into items (name, description, price) values ("Raphidophora", "Also called monstera minima.", 22);
