CREATE TABLE playground (
    equip_id serial PRIMARY KEY,
    type varchar (50) NOT NULL,
    color varchar (25) NOT NULL,
    location varchar(25) check (location in ('north', 'south', 'west', 'east', 'northeast', 'southeast', 'southwest', 'northwest')),
    install_date date
);
INSERT INTO playground(
  type, color, location, install_date)
  VALUES ('pump', 'blue', 'south', '2017-11-05');
INSERT INTO playground(
  type, color, location, install_date)
  VALUES ('heater', 'yellow', 'northwest', '2017-11-06');
INSERT INTO playground(
  type, color, location, install_date)
  VALUES ('engine', 'red', 'northwest', '2017-11-07');
