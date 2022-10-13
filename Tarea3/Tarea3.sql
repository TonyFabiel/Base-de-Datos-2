
     
/*
    1. Crear una función llamada CREAR_REGION
    • A la función se le debe pasar como parámetro un nombre de región y debe
    devolver un número, que es el código de región que calculamos dentro de la
    función.
    • Se debe crear una nueva fila con el nombre de esa REGION
    • El código de la región se debe calcular de forma automática. Para ello se debe
    averiguar cual es el código de región más alto que tenemos en la tabla en ese
    momento, le sumamos 1 y el resultado lo ponemos como el código para la
    nueva región que estamos creando
    • Debemos controlar los errores en caso que se genere un problema
    • La función debe devolver el número/ código que ha asignado a la región
    En el script debe colocar la funcion y el bloque para llamar la función.
*/

SELECT * FROM REGIONS;

CREATE OR REPLACE FUNCTION CREAR_REGION(NOMBRE_REGION VARCHAR2)
RETURN NUMBER
IS
    Codigo NUMBER;
BEGIN
    SELECT MAX(REGION_Id)+1 INTO Codigo FROM REGIONS;
    
    INSERT INTO REGIONS(REGION_ID,REGION_NAME) VALUES (Codigo,NOMBRE_REGION);
    COMMIT;
    
    RETURN Codigo;
END;

DECLARE
BEGIN
    CREAR_REGION('LatinoAmerica');
END;



/*
    2. Construir un bloque anonimo donde se declare un cursor y que imprima el nombre
    y sueldo de los empleados (utilice la tabla employees). Si durante el recorrido
    aparece el nombre Steven King (el jefe) se debe genera un
    RAISE_APPLICATION_ERROR indicando que no se puede ver el sueldo del jefe.
*/

DECLARE 
    Cursor Cursor1 is select FIRST_NAME,LAST_NAME,SALARY FROM EMPLOYEES;
    Datos Cursor1%Rowtype;
BEGIN
    OPEN Cursor1;
    LOOP
        FETCH Cursor1 into Datos;
            DBMS_OUTPUT.PUT_LINE('Nombre: '||Datos.FIRST_NAME);
            DBMS_OUTPUT.PUT_LINE('Apellido: '||Datos.LAST_NAME);
            DBMS_OUTPUT.PUT_LINE('Salario: '||Datos.SALARY);
            DBMS_OUTPUT.PUT_LINE(chr(13));
        EXIT WHEN Cursor1%NOTFOUND;
    END LOOP;
    CLOSE Cursor1;
END;


select * from employees;


select * from departments;
/*
    3. Crear un cursor con parámetros para el parametro id de departamento e imprima
    el numero de empleados de ese departamento (utilice la claúsula count).
*/

CREATE OR REPLACE FUNCTION get_COUNT(
      DEPARTAMENT_ID IN employees.department_id%TYPE)
   RETURN SYS_REFCURSOR
AS
   c_direct_reports SYS_REFCURSOR;
BEGIN

   OPEN c_direct_reports FOR 
   SELECT 
      department_id
   FROM 
      employees 
   WHERE 
      department_id = DEPARTAMENT_ID;
   RETURN c_direct_reports;
END;

DECLARE
   c_direct_reports SYS_REFCURSOR;
   l_department_id employees.department_id%TYPE;
BEGIN
    c_direct_reports := get_direct_reports(90); 
    dbms_output.put_line(c_direct_reports%ROWCOUNT);
   LOOP
      FETCH
         c_direct_reports
      INTO
         l_department_id;
      EXIT
   WHEN c_direct_reports%notfound;
      dbms_output.put_line(l_department_id);
   END LOOP;
   CLOSE c_direct_reports;
END;


/*
    4. Crear un bloque que tenga un cursor de la tabla employees.
    a. Por cada fila recuperada, si el salario es mayor de 8000 incrementamos el
    salario un 2%
    b. Si es menor de 800 incrementamos en un 3%
*/
DECLARE 
    Cursor Cursor1 is select FIRST_NAME,SALARY FROM EMPLOYEES;
    Datos Cursor1%Rowtype;
BEGIN
    OPEN Cursor1;
    LOOP
        FETCH Cursor1 into Datos;
            DBMS_OUTPUT.PUT_LINE('Nombre: '||Datos.FIRST_NAME);
            DBMS_OUTPUT.PUT_LINE('Salario actual : '||Datos.SALARY);
            if (Datos.SALARY>8000) then
            DBMS_OUTPUT.PUT_LINE('Aumento : '||Datos.SALARY*2/100);
            elsif (Datos.SALARY<800) then
            DBMS_OUTPUT.PUT_LINE('Aumento : '||Datos.SALARY*3/100);
            end if;
            DBMS_OUTPUT.PUT_LINE(chr(13));
        EXIT WHEN Cursor1%NOTFOUND;
    END LOOP;
    CLOSE Cursor1;
END;




/*
    5. Construya un procedimiento almacenado que haga las operaciones de una
    calculadora, por lo que debe recibir tres parametros de entrada, uno que contenga
    la operación a realizar (SUMA, RESTA, MULTIPLICACION, DIVISION), num1, num2 y
    declare un parametro de retorno e imprima el resultado de la operación. Maneje
    posibles excepciones.
*/

CREATE OR REPLACE PROCEDURE SP_calculadora(OPERACION IN VARCHAR2,num1 IN NUMBER,num2 IN NUMBER,resultado OUT NUMBER)  
IS
    resultado NUMBER;
BEGIN

    IF (OPERACION='SUMA') THEN
        resultado:=num1+num2;
    ELSIF (OPERACION='RESTA') THEN
        resultado:=num1-num2;
    ELSIF (OPERACION='MULTIPLICACION') THEN
        resultado:=num1*num2;
    ELSIF (OPERACION='DIVISION') THEN
        resultado:=num1/num2;
    END IF;
END;



DECLARE
    exit1 number(10);
BEGIN
 exit1:=SP_calculadora('SUMA',4,4,exit1);
END;




/*
6. Realice una copia de la tabla employee, utilice el siguiente script:

CREATE TABLE
EMPLOYEES_COPIA
(EMPLOYEE_ID NUMBER(6,0) PRIMARY KEY,
FIRST_NAME VARCHAR2(20 BYTE),
LAST_NAME VARCHAR2(25 BYTE),
EMAIL VARCHAR2(25 BYTE),
PHONE_NUMBER VARCHAR2(20 BYTE),
HIRE_DATE DATE,
JOB_ID VARCHAR2(10 BYTE),
SALARY NUMBER(8,2),
COMMISSION_PCT NUMBER(2,2),
MANAGER_ID NUMBER(6,0),
DEPARTMENT_ID NUMBER(4,0)
);
Rellene la tabla employees_copia utilizando un procedimiento almacenado, el cual no
recibirá parametros unicamente ejecutara los inserts en la nueva tabla, imprima el codigo
de error en caso de que ocurra y muestre un mensaje por pantalla que diga “Carga
Finalizada”.
*/



CREATE OR REPLACE PROCEDURE SP_INSERT_EC(EMPLOYEE_ID NUMBER,FIRST_NAME VARCHAR2,LAST_NAME VARCHAR2,EMAIL VARCHAR2,PHONE_NUMBER VARCHAR2,
HIRE_DATE DATE,JOB_ID VARCHAR2,SALARY NUMBER,COMMISSION_PCT NUMBER,MANAGER_ID NUMBER,DEPARTMENT_ID NUMBER)
IS
BEGIN
    INSERT INTO EMPLOYEES_COPIA VALUES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,
    HIRE_DATE,JOB_ID ,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID);

END;

EXECUTE SP_INSERT_EC(11,'Tony','Galo','Tony@yahoo','9922',sysdate,'20',20000,5000,3322,99);

select * from EMPLOYEES_COPIA;

