import os
import sqlite3 as sql
from functools import wraps

class DBController:
    def __init__(self, database="sales_analysis_system.db"):
        base_dir = os.path.dirname(os.path.abspath(__file__))
        self.db_path = os.path.join(base_dir, database)

    @staticmethod
    def db_operation(func):
        @wraps(func)
        def wrapper(self, *args, **kwargs):
            try:
                with sql.connect(self.db_path) as db:
                    cur = db.cursor()
                    result = func(self, cur, *args, **kwargs)
                    db.commit()
                    return result
            except sql.Error as e:
                print(f"Database error in {func.__name__}: {e}")
            except Exception as e:
                print(f"Unexpected error in {func.__name__}: {e}")
            return None
        return wrapper
        
    @db_operation
    def new_order(self, cur, order_info):
        cur.execute(
            "INSERT INTO orders VALUES (?,?,?,?,?,?,?,?,?,?)",
            (
                order_info.name,
            )
        )
        return