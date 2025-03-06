import mysql.connector

def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",  
        database="shop_db"
    )

def create_tables():
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS Customer (
        CustomerID INT PRIMARY KEY AUTO_INCREMENT,
        Name VARCHAR(100)
    );
    ""
    )
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS `Order` (
        OrderID INT PRIMARY KEY AUTO_INCREMENT,
        CustomerID INT,
        TotalAmount DECIMAL(10,2),
        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    );
    ""
    )
    db.commit()
    db.close()
    print("Tables created successfully!")

def populate_tables():
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("INSERT INTO Customer (Name) VALUES ('Alice'), ('Bob');")
    cursor.execute("INSERT INTO `Order` (CustomerID, TotalAmount) VALUES (1, 100.50), (2, 250.75);")
    db.commit()
    db.close()
    print("Tables populated with sample data!")

def query_tables():
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("SELECT * FROM Customer C JOIN `Order` O ON C.CustomerID = O.CustomerID;")
    results = cursor.fetchall()
    for row in results:
        print(row)
    db.close()

def drop_tables():
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("DROP TABLE IF EXISTS `Order`;")
    cursor.execute("DROP TABLE IF EXISTS Customer;")
    db.commit()
    db.close()
    print("Tables dropped!")

def menu():
    while True:
        print("\nMENU:")
        print("1. Create Tables")
        print("2. Populate Tables")
        print("3. Query Tables")
        print("4. Drop Tables")
        print("5. Exit")
        choice = input("Select an option: ")
        if choice == "1":
            create_tables()
        elif choice == "2":
            populate_tables()
        elif choice == "3":
            query_tables()
        elif choice == "4":
            drop_tables()
        elif choice == "5":
            print("Exiting...")
            break
        else:
            print("Invalid choice, try again.")

if __name__ == "__main__":
    menu()

# Functional Dependencies:
# - Customer(CustomerID) → Customer(Name)
# - Order(OrderID) → Order(CustomerID, TotalAmount)
# - Order(CustomerID) → Customer(Name) (via FK relationship)

# Impact Analysis:
# - Ensures data consistency through Foreign Keys.
# - Eliminates redundancy by normalizing tables (1NF, 2NF, 3NF).
# - Indexing CustomerID speeds up JOIN queries.
