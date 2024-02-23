-- creare tabele
CREATE TABLE filiale
(
    id_filiala NUMBER(6) CONSTRAINT PK_filiale PRIMARY KEY NOT NULL,
    adresa VARCHAR2(20), 
    denumire VARCHAR2(20),
    id_filiala_parinte NUMBER(6) REFERENCES filiale(id_filiala)
);

CREATE TABLE arhitecti 
(
    id_arhitect NUMBER(6) CONSTRAINT PK_arhitecti PRIMARY KEY NOT NULL,
    id_filiala NUMBER(6),
    CONSTRAINT FK_filiala FOREIGN KEY (id_filiala) REFERENCES filiale(id_filiala),
    nume VARCHAR2(20),
    prenume VARCHAR2(20),
    email VARCHAR2(20) UNIQUE,
    telefon VARCHAR2(20),
    data_nastere DATE,
    data_angajare DATE,
    adresa VARCHAR2(20),
    localitate VARCHAR2(20),
    salariu NUMBER(8,2),
    comision NUMBER(2,2)
);

CREATE TABLE specializari
(
    id_specializare NUMBER(6) CONSTRAINT PK_specializari PRIMARY KEY NOT NULL,
    denumire VARCHAR2(20),
    detalii VARCHAR2(100)
);

CREATE TABLE arhitecti_specializari
(
    id_as  NUMBER(6) CONSTRAINT PK_as PRIMARY KEY NOT NULL,
    id_specializare NUMBER(6),
    CONSTRAINT FK_specializare FOREIGN KEY (id_specializare) REFERENCES specializari(id_specializare),
    id_arhitect NUMBER(6),
    CONSTRAINT FK_arhitect FOREIGN KEY (id_arhitect) REFERENCES arhitecti(id_arhitect)
);

CREATE TABLE clienti_firma 
(
    id_client  NUMBER(6) CONSTRAINT PK_client PRIMARY KEY NOT NULL,
    nume VARCHAR2(20),
    prenume VARCHAR2(20),
    email VARCHAR2(20) UNIQUE,
    telefon VARCHAR2(20),
    adresa VARCHAR2(20),
    localitate VARCHAR2(20)
);

CREATE TABLE proiecte 
(
    id_proiect NUMBER(6) CONSTRAINT PK_proiecte PRIMARY KEY NOT NULL,
    id_client  NUMBER(6),
    CONSTRAINT FK_client FOREIGN KEY (id_client) REFERENCES clienti_firma(id_client),
    denumire VARCHAR2(20),
    valoare NUMBER(8,2),
    tip_proiect VARCHAR2(20),
    descriere VARCHAR2(100),
    data_contract DATE,
    termen_finalizare DATE,
    locatie VARCHAR2(20)
);

CREATE TABLE arhitecti_proiecte
(
    id_ap  NUMBER(6) CONSTRAINT PK_ap PRIMARY KEY NOT NULL,
    id_arhitect NUMBER(6),
    CONSTRAINT FK_arhitect_a_p FOREIGN KEY (id_arhitect) REFERENCES arhitecti(id_arhitect),
    id_proiect NUMBER(6),
    CONSTRAINT FK_proiecte_a_p FOREIGN KEY (id_proiect) REFERENCES proiecte(id_proiect),
    data_inceput DATE
);
    

--Actualizarea structurii tabelelor ?i modificarea restric?iilor de integritate

--Sa se adauge o coloana noua in tabela CLIENTI_FIRMA
ALTER TABLE clienti_firma
ADD tip_client VARCHAR2(20);
    
--S? se adauge o restric?ie pe coloana email din tabela ARHITECTI 
ALTER TABLE arhitecti
ADD CONSTRAINT check_email check (email like'%@gmail.com' or email like'%@yahoo.com');

--S? se adauge o restric?ie pe coloana telefon din tabela CLIENTI_FIRMA
ALTER TABLE clienti_firma
ADD CONSTRAINT check_telefon check(length(telefon)=10); 

--S? se dezactiveze restric?ia de pe coloana telefon.
ALTER TABLE clienti_firma
DROP CONSTRAINT check_telefon;

--S? se adauge restric?ia ca tipul clientului s? fie persoan? fizic? sau persoan? juridic?.
ALTER TABLE clienti_firma
ADD CONSTRAINT check_tipCLient check(tip_client IN ('persoana fizica','persoana juridica'));

--verificare
INSERT INTO clienti_firma VALUES(1,'Marinescu','Simona','simonaM@gmail.com','0755896734','str Frumoasa 34','Bucuresti','persoana fizica');

--S? se adauge restric?ia ca tipul proiectului s? se regaseasc? ?n urm?toarea list?: {infrastructur?, reziden?ial?, comercial?, cultural?, design de interior, peisagistic?, restaurare, amenajare urbana,cercetare si dezvoltare, arhitectura medicala}
ALTER TABLE proiecte
ADD CONSTRAINT check_tipProiect check(tip_proiect IN (
'infrastructura','rezidential','comercial','cultural','design de interior','peisagistica','restaurare','amenajare urbana','cercetare si dezvoltare', 'arhitectura medicala'
));

--S? se renumeasc? coloana detalii din tabela SPECIALIZARI ?n descriere
ALTER TABLE specializari
RENAME COLUMN detalii TO descriere;

--S? se modifice tipul coloanei adres? ?n VARCHAR2(50).
ALTER TABLE arhitecti
MODIFY (adresa VARCHAR2(50));

ALTER TABLE filiale
MODIFY (adresa VARCHAR2(50));

ALTER TABLE clienti_firma
MODIFY (adresa VARCHAR2(50));

--S? se adauge constr?ngeri NOT NULL pentru c?mpurile nume, prenume, email, telefon, at?t din cadrul tabelei ARHITECTI, c?t ?i din cadrul tabelei CLIEN?I.
ALTER TABLE arhitecti MODIFY(nume NOT NULL, prenume NOT NULL, email NOT NULL, telefon NOT NULL);
ALTER TABLE clienti_firma MODIFY(nume NOT NULL, prenume NOT NULL, email NOT NULL, telefon NOT NULL);

-- S? se adauge restric?ia ca salariul arhitectului s? fie cuprins ?ntre 3000 ?i 30000 RON.
ALTER TABLE arhitecti
ADD CONSTRAINT check_salariu check(salariu BETWEEN 3000 AND 30000);

--S? se modifice tipul coloanelor denumire ?i descriere ?n VARCHAR2(50), respectiv VARCHAR2(500) din cadrul tabelei SPECIALIZARI.
ALTER TABLE specializari
MODIFY (denumire VARCHAR2(50),descriere VARCHAR2(500));

--S? se scoat? restric?ia NOT NULL de pe coloana prenume din tabela CLIENTI.
ALTER TABLE clienti_firma
MODIFY prenume VARCHAR2(20) NULL;

--S? se modifice tipul coloanei email ?n VARCHAR2(50)
ALTER TABLE clienti_firma
MODIFY (email VARCHAR2(50), nume VARCHAR2(50));

--S? se adauge restric?ia ca doar ?n cazul persoanelor juridice s? poat? r?m?ne coloana prenume null.
ALTER TABLE clienti_firma
ADD CONSTRAINT check_tip CHECK( (tip_client = 'persoana fizica' AND prenume IS NOT NULL) OR (tip_client = 'persoana juridica' AND prenume IS NULL));

--S? se adauge coloana discount ?n cadrul tabelei Clienti_firma.

ALTER TABLE clienti_firma
ADD discount NUMBER(2,2);

--adaugare inregistrari filiale
INSERT INTO filiale VALUES (1,'str. Primaverii 15','Bucharest Design Hub',NULL);
INSERT INTO filiale VALUES (2, 'str. lalelelor 6', 'Constanta Arch Studio',1);
INSERT INTO filiale VALUES (3, 'bd. Mihai Viteazu 23', 'Cluj-Napoca Architects',1);
INSERT INTO filiale VALUES (4, 'str. Independentei 8', 'Timisoara Architecture Solutions',1);
INSERT INTO filiale VALUES (5, 'str. Stefan cel Mare 11', 'Iasi Architectural Creations',2);
INSERT INTO filiale VALUES (6, 'bd. Unirii 20', 'Brasov Design',2);
INSERT INTO filiale VALUES (7, 'str. Victoriei 7', 'Galati Arch Innovations',3);
INSERT INTO filiale VALUES (8, 'bd. Carol I 14', 'Craiova Creative Spaces',3);
INSERT INTO filiale VALUES (9, 'str. Republicii 5', 'Ploiesti Blueprint Studios',4);
INSERT INTO filiale VALUES (10, 'bd. Revolutiei 12', 'Oradea Modern Architects',4);

--
delete from filiale;
--

--adaugare inregistrari arhitecti
INSERT INTO arhitecti VALUES (1,1,'Popescu','Rares','raresp@gmail.com','0785467239',TO_DATE('1975-09-01','YYYY-MM-DD'),TO_DATE('2005-11-23','YYYY-MM-DD'),'str. Liviu Rebreanu','Bucuresti',25000,0.5);
INSERT INTO arhitecti VALUES (2, 2, 'Ionescu', 'Andreea', 'andreea@gmail.com', '0754321987', TO_DATE('1980-05-10', 'YYYY-MM-DD'), TO_DATE('2010-02-15', 'YYYY-MM-DD'), 'bd. Aviatorilor 15', 'Iasi', 28200, 0.1);
INSERT INTO arhitecti VALUES (3, 3, 'Mihai', 'Diana', 'diana.m@gmail.com', '0723456789', TO_DATE('1983-12-18', 'YYYY-MM-DD'), TO_DATE('2015-08-20', 'YYYY-MM-DD'), 'str. Dorobanti 7', 'Timisoara', 10000.00, 0.15);
INSERT INTO arhitecti VALUES (4, 4, 'Vasile', 'Elena', 'elena.v@gmail.com', '0767890123', TO_DATE('1987-07-25', 'YYYY-MM-DD'), TO_DATE('2018-03-05', 'YYYY-MM-DD'), 'bd. Unirii 21', 'Brasov', 25000, 0.2);
INSERT INTO arhitecti VALUES (5, 6, 'Popa', 'Alexandru', 'alex.p@yahoo.com', '0732109876', TO_DATE('1992-03-08', 'YYYY-MM-DD'), TO_DATE('2021-01-10', 'YYYY-MM-DD'), 'str. Revolutiei 3', 'Cluj-Napoca', 5500, 0.32);
INSERT INTO arhitecti VALUES (6, 7, 'Dumitru', 'Ana-Maria', 'ana.maria@gmail.com', '0745612398', TO_DATE('1985-11-30', 'YYYY-MM-DD'), TO_DATE('2017-09-12', 'YYYY-MM-DD'), 'bd. Independentei 18', 'Timisoara', 30000, 0.1);
INSERT INTO arhitecti VALUES (7, 5, 'Constantin', 'Elena', 'elena.ctin@gmail.com', '0789123456', TO_DATE('1989-09-02', 'YYYY-MM-DD'), TO_DATE('2019-12-01', 'YYYY-MM-DD'), 'str. Victoriei 12', 'Constanta', 21000, 0.14);
INSERT INTO arhitecti VALUES (8, 9, 'Georgescu', 'Cristian', 'cristi.g@yahoo.com', '0756234891', TO_DATE('1994-06-15', 'YYYY-MM-DD'), TO_DATE('2023-06-20', 'YYYY-MM-DD'), 'bd. Mihai Bravu 5', 'Cluj-Napoca', 8800, 0.3);
INSERT INTO arhitecti VALUES (9, 8, 'Iordache', 'Monica', 'monica.i@gmail.com', '0721345678', TO_DATE('1981-02-14', 'YYYY-MM-DD'), TO_DATE('2010-04-25', 'YYYY-MM-DD'), 'str. Carol I 9', 'Brasov', 17000, 0.2);
INSERT INTO arhitecti VALUES (10, 10, 'Stanciu', 'Gabriel', 'gabriel.s@gmail.com', '0798765432', TO_DATE('1990-10-20', 'YYYY-MM-DD'), TO_DATE('2022-09-08', 'YYYY-MM-DD'), 'bd. Decebal 14', 'Constanta', 13000, 0.2);
INSERT INTO arhitecti VALUES (11, 1, 'Ionescu', 'Elena', 'elena.i@yahoo.com', '0745123456', TO_DATE('1986-08-22', 'YYYY-MM-DD'), TO_DATE('2017-11-10', 'YYYY-MM-DD'), 'str. Cuza Voda 9', 'Iasi', 23000, 0.12);
INSERT INTO arhitecti VALUES (12, 2, 'Pop', 'Marian', 'marian.pop@gmail.com', '0789234567', TO_DATE('1993-04-05', 'YYYY-MM-DD'), TO_DATE('2021-05-15', 'YYYY-MM-DD'), 'bd. Decebal 11', 'Oradea', 9000, 0.1);
INSERT INTO arhitecti VALUES (13, 3, 'Dumitrescu', 'Catalina', 'catalina.d@gmail.com', '0723344556', TO_DATE('1988-11-12', 'YYYY-MM-DD'), TO_DATE('2019-09-20', 'YYYY-MM-DD'), 'str. Independentei 7', 'Oradea', 18000, 0.18);

--adaugare inregistrari specializari
INSERT INTO specializari VALUES (1,'Arhitectura infrastructurala','planificarea si proiectarea structurilor si spatiilor asociate cu infrastructura, cum ar fi drumuri, poduri, statii de tren, parcari');
INSERT INTO specializari VALUES (2,'Arhitectura rezidentiala', 'proiectarea si planificarea locuintelor, inclusiv case unifamiliare, apartamente si complexuri rezidentiale');
INSERT INTO specializari VALUES (3,'Arhitectura comerciala', 'proiectarea spatiilor destinate activitatilor comerciale, cum ar fi magazine, centre comerciale, birouri, hoteluri si alte facilitati similare.');
INSERT INTO specializari VALUES (4,'Arhitectura culturala ', 'constructii precum muzee, teatre, sali de concerte sau alte facilitati culturale.');
INSERT INTO specializari VALUES (5,'Design de Interior', 'aspectele interioare ale spatiilor, inclusiv mobilierul, finisajele, iluminatul si atmosfera generala.');
INSERT INTO specializari VALUES (6,'Arhitectura peisagistica',' planificarea si proiectarea spatiilor exterioare, cum ar fi parcuri, gradini, terenuri de joaca si alte elemente exterioare.');
INSERT INTO specializari VALUES (7,'Restaurare arhitecturala',' restaurarea si conservarea cladirilor istorice sau a altor structuri importante, mentin?nd autenticitatea lor.');
INSERT INTO specializari VALUES (8,'arhitectura urbana','planificarea si proiectarea spatiilor urbane la nivel de oras sau cartier, abordand aspecte precum traficul, infrastructura, spatiile publice si aspectele estetice.');
INSERT INTO specializari VALUES (9,'Arhitectura de Cercetare si Dezvoltare','proiectarea spatiilor de cercetare si laboratoarelor, asigurand conditii optime pentru activitati de cercetare stiintifica si dezvoltare tehnologica.');
INSERT INTO specializari VALUES (10, 'Arhitectura Medicala','proiectarea cladirilor care optimizeaza eficienta energetica, reducand consumul de energie si utilizand surse regenerabile.');

--adaugare inregistrari arhitecti-specializari
INSERT INTO arhitecti_specializari VALUES (1,1,2);
INSERT INTO arhitecti_specializari VALUES (2,10,6);
INSERT INTO arhitecti_specializari VALUES (3,3,1);
INSERT INTO arhitecti_specializari VALUES (4,7,4);
INSERT INTO arhitecti_specializari VALUES (5,4,7);
INSERT INTO arhitecti_specializari VALUES (6,9,3);
INSERT INTO arhitecti_specializari VALUES (7,2,8);
INSERT INTO arhitecti_specializari VALUES (8,6,10);
INSERT INTO arhitecti_specializari VALUES (9,5,9);
INSERT INTO arhitecti_specializari VALUES (10,1,5);

--aduagare inregistrari clienti
-- Persoane fizice
INSERT INTO clienti_firma VALUES (1,'Mironescu','Patricia','patricia.m@gmail.com','0738776329','bd. Mihai Bravu','Bucuresti','persoana fizica');
INSERT INTO clienti_firma VALUES (2,'Popovici','Adrian','adrian.p@gmail.com','0723894567','bd. Marasesti 3','Bucuresti','persoana fizica');
INSERT INTO clienti_firma VALUES (3, 'Popescu', 'Ion', 'popescu.ion@gmail.com', '0721123456', 'str. Florilor 7', 'Bucuresti', 'persoana fizica');
INSERT INTO clienti_firma VALUES (4, 'Ionescu', 'Ana', 'ana.ionescu@yahoo.com', '0756234890', 'bd. Unirii 15', 'Cluj-Napoca', 'persoana fizica');
INSERT INTO clienti_firma VALUES (5, 'Dumitru', 'Maria', 'maria.dumitru@gmail.com', '0789345678', 'str. Independentei 23', 'Timisoara', 'persoana fizica');
-- Persoane juridice
INSERT INTO clienti_firma VALUES (6, 'SmartSpaces Development SRL', NULL, 'contact@smartspaces.ro', '0267890123', 'str. Inovatiei 6', 'Iasi', 'persoana juridica');
INSERT INTO clienti_firma VALUES (7, 'InfiniteDesign Solutions SRL', NULL, 'info@infinitedesign.ro', '0301122334', 'bd. Creativitatii 9', 'Oradea', 'persoana juridica');
INSERT INTO clienti_firma VALUES (8, 'SC ArhitecturaDesign SRL', NULL, 'contact@arhitecturadesign.ro', '0214567890', 'bd. Victoriei 10', 'Bucuresti', 'persoana juridica');
INSERT INTO clienti_firma VALUES (9, 'ABC Constructii SA', NULL, 'office@abcconstructii.ro', '0312345678', 'str. Constructorilor 3', 'Cluj-Napoca', 'persoana juridica');
INSERT INTO clienti_firma VALUES (10, 'GreenSpaces Invest SRL', NULL, 'info@greenspaces.ro', '0256789012', 'bd. Parcului 8', 'Timisoara', 'persoana juridica');
INSERT INTO clienti_firma VALUES (11, 'ArhitecturaPlus SA', NULL, 'contact@arhitecturaplus.ro', '0345678901', 'str. Libertatii 12', 'Constanta', 'persoana juridica');
INSERT INTO clienti_firma VALUES (12, 'ProUrbanism SRL', NULL, 'office@prourbanism.ro', '0289012345', 'bd. Unirii 18', 'Brasov', 'persoana juridica');

----aduagare inregistrari proiecte
INSERT INTO proiecte VALUES (1, 1, 'Cladire Rezidentiala', 950000, 'rezidential', 'Constructie de bloc cu apartamente', TO_DATE('2020-01-15', 'YYYY-MM-DD'), TO_DATE('2022-02-28', 'YYYY-MM-DD'), 'Bucuresti');
INSERT INTO proiecte VALUES (2, 2, 'Design Interior Penthouse', 50000, 'design de interior', 'Amenajare interioara a unui penthouse din zona centrala in stil minimalist', TO_DATE('2021-05-10', 'YYYY-MM-DD'), TO_DATE('2021-09-30', 'YYYY-MM-DD'), 'Cluj-Napoca');
INSERT INTO proiecte VALUES (3, 3, 'Muzeu de Arta Moderna', 500000, 'cultural', 'Proiectare si constructie muzeu', TO_DATE('2017-03-20', 'YYYY-MM-DD'), TO_DATE('2020-05-15', 'YYYY-MM-DD'), 'Timisoara');
INSERT INTO proiecte VALUES (4, 4, 'Spatiu de Birouri', 200000, 'comercial', 'Amenajare birouri', TO_DATE('2021-07-12', 'YYYY-MM-DD'), TO_DATE('2022-03-30', 'YYYY-MM-DD'), 'Constanta');
INSERT INTO proiecte VALUES (5, 5, 'Gradina Publica', 150000, 'peisagistica', 'Amenajare spatiu verde', TO_DATE('2022-02-28', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 'Brasov');
INSERT INTO proiecte VALUES (6, 6, 'Restaurare Cladire Istorica', 250000, 'restaurare', 'Lucrari de restaurare si conservare', TO_DATE('2021-10-05', 'YYYY-MM-DD'), TO_DATE('2022-12-20', 'YYYY-MM-DD'), 'Iasi');
INSERT INTO proiecte VALUES (7, 7, 'Plan Urbanistic General', 180000, 'amenajare urbana', 'Elaborare plan urbanistic', TO_DATE('2022-04-15', 'YYYY-MM-DD'), TO_DATE('2023-06-30', 'YYYY-MM-DD'), 'Cluj-Napoca');
INSERT INTO proiecte VALUES (8, 8, 'Laborator de Cercetare', 800000, 'cercetare si dezvoltare', 'Proiectare laborator de cercetare', TO_DATE('2021-08-20', 'YYYY-MM-DD'), TO_DATE('2022-10-30', 'YYYY-MM-DD'), 'Timisoara');
INSERT INTO proiecte VALUES (9, 9, 'Clinica Medicala', 999000, 'arhitectura medicala', 'Constructie clinica medicala', TO_DATE('2022-01-10', 'YYYY-MM-DD'), TO_DATE('2023-03-25', 'YYYY-MM-DD'), 'Constanta');
INSERT INTO proiecte VALUES (10, 10, 'Restaurare Casa', 50000, 'restaurare', 'Restaurarea unei case de 200 de ani din zona Foisorul de Foc', TO_DATE('2019-06-15', 'YYYY-MM-DD'), TO_DATE('2022-08-31', 'YYYY-MM-DD'), 'Bucuresti');
INSERT INTO proiecte VALUES (11, 11, 'Casa de Vacanta', 200000, 'design de interior', 'Amenajare casa de vacanta in zona montana, in stil industrial', TO_DATE('2021-03-01', 'YYYY-MM-DD'), TO_DATE('2023-04-20', 'YYYY-MM-DD'), 'Iasi');
INSERT INTO proiecte VALUES (12, 12, 'Centru de Recreere', 120000, 'rezidential', 'Constructie complex rezidential', TO_DATE('2018-09-10', 'YYYY-MM-DD'), TO_DATE('2022-11-15', 'YYYY-MM-DD'), 'Oradea');
INSERT INTO proiecte VALUES (13, 1, 'Parc Tehnologic', 300000, 'infrastructura', 'Dezvoltare parc tehnic', TO_DATE('2022-02-15', 'YYYY-MM-DD'), TO_DATE('2023-04-01', 'YYYY-MM-DD'), 'Bucuresti');
INSERT INTO proiecte VALUES (14, 2, 'Centru de Evenimente', 900000, 'comercial', 'Constructie spatiu pentru evenimente', TO_DATE('2017-07-01', 'YYYY-MM-DD'), TO_DATE('2018-08-15', 'YYYY-MM-DD'), 'Cluj-Napoca');

----aduagare inregistrari arhitecti-proiecte
INSERT INTO arhitecti_proiecte VALUES (1,5,1, TO_DATE('2020-07-20', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (2,13,2, TO_DATE('2021-09-10', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (3,8,3, TO_DATE('2017-06-15', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (4,3,4, TO_DATE('2021-10-17', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (5,1,5, TO_DATE('2022-03-23', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (6,10,6, TO_DATE('2022-01-27', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (7,12,7, TO_DATE('2022-05-09', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (8,4,8, TO_DATE('2021-10-26', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (9,6,9, TO_DATE('2022-03-04', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (10,9,10, TO_DATE('2019-10-14', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (11,2,11, TO_DATE('2021-07-01', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (12,5,12, TO_DATE('2019-02-15', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (13,7,13, TO_DATE('2022-09-30', 'YYYY-MM-DD'));
INSERT INTO arhitecti_proiecte VALUES (14,11,14, TO_DATE('2017-11-05', 'YYYY-MM-DD'));

--actualizarea inregistrarilor

--S? se actualizeze num?rul de telefon al clientului Ionescu Ana (0745773286)
UPDATE clienti_firma SET telefon = '0745773286' WHERE nume = 'Ionescu';
--S? se creasc? cu 10% salariul arhitec?ilor care primesc mai pu?in de 10000 lei.
UPDATE arhitecti SET salariu = 1.1 * salariu WHERE salariu <10000;
--S? se schimbe adresa filialei cu denumirea ?Craiova Creative Spaces?, deoarece sediul s-a mutat: str. Craiove?ti 17a.
UPDATE filiale SET adresa = 'str. Craiovesti 17a' WHERE denumire = 'Craiova Creative Spaces';
--


--stergerea si recuperarea unei tabele
DROP TABLE filiale CASCADE CONSTRAINTS;

FLASHBACK TABLE filiale TO BEFORE DROP;

--Exemple de interog?ri variate (min 20)
--incluz?nd ?i operatorii UNION, INTERSECT, MINUS, expresiile DECODE ?i CASE, cereri imbricate, diverse func?ii single-row, func?ii de grup, structuri ierarhice, jonctiuni.
--  CERINTE
--S? se afi?eze arhitec?ii ?i proiectul/proiectele la care lucreaz? fiecare, grupate dup? localit??i.
SELECT a.nume, a.prenume, ap.data_inceput, p.denumire
FROM arhitecti a, proiecte p, arhitecti_proiecte ap
WHERE a.id_arhitect = ap.id_arhitect
AND ap.id_proiect = p.id_proiect;

--S? se afi?eze numele ?i prenumele arhitec?ilor care sunt asigna?i la mai mult de 1 proiect. 
SELECT a.id_arhitect, a.nume, a.prenume,COUNT(ap.id_proiect) AS numar_proiecte_asignate
FROM arhitecti a, arhitecti_proiecte ap
WHERE a.id_arhitect = ap.id_arhitect
GROUP BY a.id_arhitect, a.nume, a.prenume
HAVING COUNT(ap.id_proiect) > 1;

--S? se calculeze valoarea total? a proiectelor care fac parte din categoria design de interior.
SELECT SUM(valoare) AS valoare_totala_proiecte_design_interior
FROM proiecte
WHERE tip_proiect = 'design de interior';

--S? se afi?eze numele, prenumele, salariul ?i denumirea filialei pentru arhitec?ii din Bucure?ti, Constan?a ?i Oradea. Din aceste înregistr?ri, s? se elimine arhitec?ii care au fost angaja?i înainte de 2016. *merge, minus, having incearca
SELECT a.nume, a.prenume, a.salariu, f.denumire
FROM arhitecti a, filiale f
WHERE a.id_filiala = f.id_filiala
AND a.localitate IN ('Bucuresti', 'Constanta', 'Oradea')
    MINUS 
SELECT a.nume, a.prenume, a.salariu, f.denumire
FROM arhitecti a, filiale f
WHERE a.id_filiala = f.id_filiala
AND a.localitate IN ('Bucuresti', 'Constanta', 'Oradea')
GROUP BY a.nume, a.prenume, a.salariu, f.denumire
HAVING MIN(EXTRACT(YEAR FROM a.data_angajare)) >= 2016;

--S? se calculeze comisionul în func?ie de data angaj?rii, astfel: *union *order by (afis crescator dupa data)
SELECT nume, prenume, data_angajare, salariu, comision, 1.05*((comision+1)*salariu) AS suma_finala_primita
FROM arhitecti
WHERE MONTHS_BETWEEN(SYSDATE, data_angajare) BETWEEN 12 AND 24
UNION
SELECT nume, prenume, data_angajare, salariu, comision, 1.1*((comision+1)*salariu) AS suma_finala_primita
FROM arhitecti
WHERE MONTHS_BETWEEN(SYSDATE, data_angajare) BETWEEN 24 AND 60
UNION
SELECT nume, prenume, data_angajare, salariu, comision, 1.2*((comision+1)*salariu) AS suma_finala_primita
FROM arhitecti
WHERE MONTHS_BETWEEN(SYSDATE, data_angajare) BETWEEN 60 AND 240
UNION
SELECT nume, prenume, data_angajare, salariu, comision, salariu AS suma_finala_primita
FROM arhitecti
WHERE MONTHS_BETWEEN(SYSDATE, data_angajare) BETWEEN 0 AND 12

ORDER BY data_angajare DESC;

--S? se afi?eze clien?ii care vor beneficia de discount pentru proiectul solicitat. Condi?iile pentru ob?inerea lui sunt:
SELECT nume || ' ' || prenume AS clienti_care_benificiaza_de_discount
FROM clienti_firma
WHERE tip_client = 'persoana fizica'
INTERSECT
SELECT cf.nume ||  ' ' || cf.prenume  AS clienti_care_benificiaza_de_discount
FROM clienti_firma cf, proiecte p
WHERE cf.id_client = p.id_client
AND  p.tip_proiect = 'design de interior';

--S? se afi?eze num?rul de luni între data semn?rii contractului ?i termenul de finalizare al proiectului. *MONTHS_BETWEEN(sysdate, data)
SELECT id_proiect, denumire,ROUND(MONTHS_BETWEEN(termen_finalizare, data_contract)) AS numar_luni
FROM proiecte;

--S? se afi?eze urm?toarea zi de luni dup? termenul de finalizare ?i ultima zi din lun? care face parte din perioada de desf??urare a proiectului. *NEXT_DAY(), *LAST_DAY()
SELECT p.id_proiect, p.denumire,
    NEXT_DAY(p.termen_finalizare, 'MONDAY') AS urmatoarea_zi_luni,
    LAST_DAY(p.termen_finalizare) AS ultima_zi_din_luna
FROM proiecte p;

--S? se afi?eze proiectele finalizate în anul trecut ?i data corespunz?toare dup? 6 luni de la semnarea contractului. *ADD_MONTHS(
SELECT p.id_proiect, p.denumire, p.data_contract AS data_semarii_contractului,
    ADD_MONTHS(p.data_contract, 6) AS data_dupa_6_luni,
    p.termen_finalizare
FROM proiecte p
WHERE EXTRACT(YEAR FROM p.termen_finalizare) = EXTRACT(YEAR FROM SYSDATE) - 1;

--S? se afi?eze arhitec?ii care au fost angaja?i în anii 2021 ?i 2022. *extract
SELECT id_arhitect, nume, prenume, data_angajare
FROM arhitecti
WHERE EXTRACT(YEAR FROM data_angajare) IN (2021, 2022);

--S? se calculeze diferit salariul calculat cu comisionul pentru arhitec?i, în func?ie de categoria de salariu din care fac parte. *case

SELECT id_arhitect, nume, prenume,salariu,
    CASE
        WHEN salariu >= 5000 THEN salariu * 0.1  
        WHEN salariu >= 3000 THEN salariu * 0.08 
        ELSE salariu * 0.05                      
    END AS salariu_final
FROM arhitecti;

--S? se calculeze diferit discountul pentru persoane fizice ?i juridice, astfel: *decode
SELECT cf.id_client, cf.nume, cf.prenume, cf.adresa, cf.tip_client, p.valoare,
    DECODE(cf.tip_client,
           'persoana fizica', p.valoare * 0.10,  
           'persoana juridica', p.valoare * 0.20    
           ) AS valoare_cu_discount
FROM clienti_firma cf, proiecte p
WHERE cf.id_client = p.id_client
ORDER BY p.valoare DESC;

--S? se afi?eze specializ?rile arhitectului cu ID = 5. 
SELECT a.nume, a.prenume, s.denumire, s.descriere
FROM arhitecti a, arhitecti_specializari a_s, specializari s
WHERE a.id_arhitect = a_s.id_arhitect
AND a_s.id_specializare = s.id_specializare
AND a.id_arhitect = 5;
--S? se afi?eze filialele a c?ror denumire începe cu litera ‘B’. *substr(denumire,1,1)
SELECT id_filiala, adresa, denumire
FROM filiale
WHERE SUBSTR(denumire, 1, 1) = 'B';

--S? se genereze nume de utilizator arhitec?ilor cu salariul mai mare de 20000, conform numelui ?i al ID-ului.
SELECT CONCAT(lower(nume), id_arhitect)
FROM arhitecti 
WHERE salariu > 20000
ORDER BY salariu;

--S? se afi?eze arhitec?ii ?i valoarea medie a salariilor acestora, în ordine descresc?toare, numai pentru arhitec?ii care sunt n?scu?i dup? 1980. 
SELECT id_arhitect, nume, prenume, ROUND(salariu, 2) AS medie_salariu
FROM arhitecti
WHERE EXTRACT(YEAR FROM data_nastere) > 1980
ORDER BY medie_salariu DESC;

--S? se afi?eze numele, prenumele, salariul ?i data angaj?rii pentru arhitec?ii care au salariul mai mare decât media salariilor tuturor arhitec?ilor. Ordona?i rezultatele dup? numele arhitectului.
SELECT nume, prenume, salariu, data_angajare
FROM arhitecti
WHERE salariu > (SELECT AVG(salariu) FROM arhitecti)
ORDER BY nume;

--S? se afi?eze prenumele fiec?rui client, dac? acesta este nul, se va afi?a numele, iar dac? ?i acesta este nul, se va afi?a “Nu este specificat”. *Coalesce
SELECT
    COALESCE(prenume, nume, 'Nu este specificat') AS nume_client
FROM
    clienti_firma;

--S? se afi?eze câ?i clien?i sunt din Bucure?ti ?i sunt persoane fizice. *count
SELECT COUNT(*) AS numar_clienti_bucuresti_persoane_fizice
FROM clienti_firma
WHERE localitate = 'Bucuresti';

--S? se calculeze valoarea maxim?, valoarea medie, valoarea minim? ?i valoarea total? a proiectelor. *avg, max, min, sum
SELECT
    MAX(valoare) AS valoare_maxima,
    AVG(valoare) AS valoare_medie,
    MIN(valoare) AS valoare_minima,
    SUM(valoare) AS valoare_totala
FROM proiecte;


--structuri ierarhice
--S? se afi?eze ierarhia filialelor firmei de arhitectur?.
SELECT
    CONNECT_BY_ROOT denumire AS filiala_radacina,
    CONNECT_BY_ISLEAF AS este_frunza,
    LEVEL AS nivel,
    PRIOR denumire AS parinte,
    denumire AS filiala
FROM filiale
START WITH id_filiala_parinte IS NULL
CONNECT BY PRIOR id_filiala = id_filiala_parinte;

--vederi
CREATE OR REPLACE VIEW v_proiecte_2000000
AS SELECT denumire, valoare, tip_proiect, data_contract, termen_finalizare, descriere FROM proiecte
WHERE valoare >= 200000
WITH READ ONLY;

--sinonime
CREATE SYNONYM c FOR clienti;
SELECT * FROM USER_SYNONYMS;
--secvente
CREATE SEQUENCE seq_idspec
START WITH 100 INCREMENT BY 10
MAXVALUE 1000 NOCYCLE;

INSERT INTO specializari VALUES (seq_idspec.NEXTVAL, 'Arhitectura sustenabila','Se concentreaz? pe proiectarea ?i construirea cl?dirilor într-un mod ecologic ?i eficient din punct de vedere energetic.');
INSERT INTO specializari VALUES (seq_idspec.NEXTVAL, 'Arhitectur? Efemer?', 'Se concentreaz? pe proiectarea structurilor temporare sau a instala?iilor care servesc scopurilor specifice pentru evenimente sau perioade limitate de timp.');
delete from specializari where id_specializare = 150;
--indecsi
CREATE INDEX index_nume ON arhitecti(nume);






