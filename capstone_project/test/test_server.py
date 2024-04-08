"""
This module contains tests for the server functionality.
"""
import sqlite3
import unittest
import server

# pylint test_server.py - use this to test for memory leaks

# I could carefully create the tables to take up less space by adjusting the size of each col
# I should also calculate the size of one row for each table so that I have a very good picture of how much memory I am using

class TestDatabase(unittest.TestCase):
    """
    Test cases for the server functionality.
    """

    @classmethod
    def setUpClass(cls):
        cls.connection = sqlite3.connect(':memory:')
        cls.cursor = cls.connection.cursor()
        cls.create_schema(cls.cursor)
        cls.insert_test_data(cls.cursor)
        cls.connection.commit()
        print("opening from setup")

    @classmethod
    def tearDownClass(cls):
        print()
        print("closing from tear down")
        cls.cursor.close()
        cls.connection.close()

    @classmethod
    def create_schema(cls, cursor):
        """
        create schema: 
            size of one row in each table:
            -- Patient: 35 bytes
            -- Incident: 59 bytes
            -- Test: 62 bytes
            -- ReactiveTest: 38 bytes
            -- StaticTest: 42 bytes
            -- DynamicTest: 102 bytes
            -- total for a single row in each table: 338 bytes
        """
        cursor.executescript('''
            CREATE TABLE Patient (
                pID INTEGER PRIMARY KEY AUTOINCREMENT,
                pFirstName VARCHAR(4) NOT NULL,
                pLastName VARCHAR(5) NOT NULL,
                dOB DATE NOT NULL,
                height SMALLINT DEFAULT 0,
                weight SMALLINT DEFAULT 0,
                sport VARCHAR(3) DEFAULT "",
                gender VARCHAR(1) DEFAULT "",
                thirdPartyID VARCHAR(5) DEFAULT "",
                orgID SMALLINT DEFAULT 0
            );
            CREATE TABLE Incident (
                iID INTEGER PRIMARY KEY AUTOINCREMENT,
                iName VARCHAR(7) NOT NULL,
                iDate DATE NOT NULL,
                iNotes VARCHAR(30) DEFAULT "",
                pID INTEGER NOT NULL,
                FOREIGN KEY(pID) REFERENCES Patient(pID) ON DELETE CASCADE
            );
            CREATE TABLE Test (
                tID INTEGER PRIMARY KEY AUTOINCREMENT,
                tName VARCHAR(10) NOT NULL,
                tDate DATE NOT NULL,
                tNotes VARCHAR(30) DEFAULT "",
                iID INTEGER NOT NULL,
                FOREIGN KEY(iID) REFERENCES Incident(iID) ON DELETE CASCADE
            );
            CREATE TABLE ReactiveTest (
                rID INTEGER PRIMARY KEY AUTOINCREMENT,
                fTime REAL NOT NULL,
                bTime REAL NOT NULL,
                lTime REAL NOT NULL,
                rTime REAL NOT NULL,
                mTime REAL NOT NULL,
                tID INTEGER NOT NULL,
                administeredBy VARCHAR(10),
                FOREIGN KEY(tID) REFERENCES Test(tID) ON DELETE CASCADE
            );
            CREATE TABLE StaticTest (
                sID INTEGER PRIMARY KEY AUTOINCREMENT,
                tlSolidML FLOAT NOT NULL,
                tlFoamML FLOAT NOT NULL,
                slSolidML FLOAT NOT NULL,
                slFoamML FLOAT NOT NULL,
                tandSolidML FLOAT NOT NULL,
                tandFoamML FLOAT NOT NULL,
                tID INTEGER NOT NULL,
                administeredBy VARCHAR(10),
                FOREIGN KEY(tID) REFERENCES Test(tID) ON DELETE CASCADE
            );
            CREATE TABLE DynamicTest (
                dID INTEGER PRIMARY KEY AUTOINCREMENT,
                t1Duration REAL NOT NULL,
                t1TurnSpeed REAL NOT NULL,
                t1MLSway REAL NOT NULL,
                t2Duration REAL NOT NULL,
                t2TurnSpeed REAL NOT NULL,
                t2MLSway REAL NOT NULL,
                t3Duration REAL NOT NULL,
                t3TurnSpeed REAL NOT NULL,
                t3MLSway REAL NOT NULL,
                dMax REAL NOT NULL,
                dMin REAL NOT NULL,
                dMean REAL NOT NULL,
                dMedian REAL NOT NULL,
                tsMax REAL NOT NULL,
                tsMin REAL NOT NULL,
                tsMean REAL NOT NULL,
                tsMedian REAL NOT NULL,
                mlMax REAL NOT NULL,
                mlMin REAL NOT NULL,
                mlMean REAL NOT NULL,
                mlMedian REAL NOT NULL,
                tID INTEGER UNSIGNED NOT NULL,
                administeredBy VARCHAR(10),
                FOREIGN KEY(tID) REFERENCES Test(tID) ON DELETE CASCADE
            );
        ''')

    @classmethod
    def insert_test_data(cls, cursor):
        """
        create test data
        """
        cursor.executemany('''
            INSERT INTO Patient (pFirstName, pLastName, dOB, height, weight, sport, gender, thirdPartyID, orgID)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [('Test', 'Smith', '1001-02-15', 60, 195, 'Lax', 'M', '12345', 0),
              ('Lady', 'Smith', '1001-07-25', 52, 125, 'Soc', 'F', '23456', 0),
              ('Alex', 'Smith', '1001-03-05', 72, 215, 'Fot', 'M', '34567', 0)
        ])

        cursor.execute('''
            INSERT INTO Incident (iName, iDate, iNotes, pID)
            VALUES (?, ?, ?, ?)
        ''', ('Concuss', '1020-02-15', 'some iNotes', 1))

        cursor.execute('''
            INSERT INTO Test (tName, tDate, tNotes, iID)
            VALUES (?, ?, ?, ?)
        ''', ('pre inj', '1001-02-15', 'some tNotes', 1))

        cursor.execute('''
            INSERT INTO ReactiveTest (fTime, bTime, lTime, rTime, mTime, tID, administeredBy)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (1.15, 1.25, 1.35, 1.45, 1.55, 1, "Jarrod"))

        cursor.execute('''
            INSERT INTO DynamicTest (t1Duration, t1TurnSpeed, t1MLSway, 
                                     t2Duration, t2TurnSpeed, t2MLSway, 
                                     t3Duration, t3TurnSpeed, t3MLSway,
                                     dMax, dMin, dMean, dMedian,
                                     tsMax, tsMin, tsMean, tsMedian,
                                     mlMax, mlMin, mlMean, mlMedian, tID, administeredBy) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (2.05, 2.15, 2.25, 
              2.35, 2.45, 2.55,
              2.65, 2.75, 2.85,
              2.35, 2.05, 2.65, 2.35,
              2.45, 2.15, 2.75, 2.45,
              2.55, 2.25, 2.85, 2.55, 1, "Jarrod"))
        
        cursor.execute('''
            INSERT INTO StaticTest (tlSolidML, tlFoamML, slSolidML, slFoamML, tandSolidML, tandFoamML, tID, administeredBy)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', (3.15, 3.25, 3.35, 3.45, 3.55, 3.65, 1, "Jarrod"))

    def test_patient_get_all(self):
        """
        Test the functionality of the get_all_function.
        """
        with self.connection:
            patients = server.get_all_patients(self.cursor)
            for i, patient in enumerate(patients):
                if i == 0:
                    self.assertEqual(patient['pID'], 1)
                    self.assertEqual(patient['firstName'], 'Test')
                    self.assertEqual(patient['lastName'], 'Smith')
                elif i == 1:
                    self.assertEqual(patient['pID'], 2)
                    self.assertEqual(patient['firstName'], 'Lady')
                    self.assertEqual(patient['lastName'], 'Smith')
                elif i == 2:
                    self.assertEqual(patient['pID'], 3)
                    self.assertEqual(patient['firstName'], 'Alex')
                    self.assertEqual(patient['lastName'], 'Smith')
    
    def test_patient_get_one(self):
        """
        Test the functionality of the get_one_function.
        """
        with self.connection:
            patient = server.get_patient_data(1, self.cursor, True)
            self.assertEqual(patient["pID"], 1)
            incidents = patient['incidents']
            for incident in incidents:
                self.assertEqual(incident['iID'], 1)
                self.assertEqual(incident['iName'], 'Concuss')
                self.assertEqual(incident['iDate'], '1020-02-15')

            

    def test_patient_update_value(self):
        """
        Test the functionality of the update_function.
        """
        # Perform the update
        with self.connection:
            self.cursor.execute("BEGIN")
            self.cursor.execute("UPDATE Patient SET pFirstName = ? where pID=1", ('Testing',))
            data = {"pID": 1, "firstName": "John"}
            sql = server.generate_update_sql(data, self.cursor)
            first_name = server.get_updated_patient_data(1, self.cursor, True)
            self.assertEqual(first_name["firstName"], 'John')
            # Rollback to the initial state
            self.connection.rollback()

        # Check if the value has been rolled back
        self.cursor.execute("SELECT * FROM Patient WHERE pID = 1")
        rolled_first_name = self.cursor.fetchone()[1]
        self.assertEqual(rolled_first_name, 'Test')

    def test_delete_patient(self):
        pass

if __name__ == '__main__':
    unittest.main()
