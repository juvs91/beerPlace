create table  location(
id int NOT NULL AUTO_INCREMENT,
name varchar(250),
sate varchar(250),
country varchar(250),
PRIMARY KEY (id),
)engine innoDB;

create table beer(
id int NOT NULL AUTO_INCREMENT,
name varchar(250),
idCity int NOT NULL,
idType int NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (idType) REFERENCES type(id) on delete cascade on update cascade,
FOREIGN KEY (idCity) REFERENCES city(id) on delete cascade on update cascade

)engine innoDB;  

create table type(
id int NOT NULL AUTO_INCREMENT,
name varchar(250),
PRIMARY KEY (id)
)engine innoDB; 

create table user(
id int NOT NULL AUTO_INCREMENT,
PRIMARY KEY (id)
)engine innoDB;

create table place(
id int NOT NULL AUTO_INCREMENT,
idLocation int NOT NULL,
latitude varchar(1024),
PRIMARY KEY (id),
FOREIGN KEY (idLocation) REFERENCES location(id) on delete cascade on update cascade
)engine innoDB; 
 
create table vote(
idBeer int NOT NULL,
idUser int NOT NULL,
PRIMARY KEY (idBeer,idUser),
FOREIGN KEY (idBeer) REFERENCES beer(id) on delete cascade on update cascade,
FOREIGN KEY (idUser) REFERENCES user(id) on delete cascade on update cascade,
)engine innoDB;



