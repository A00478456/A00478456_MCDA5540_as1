# the script invokes the program that will read the file authors.csv and will produce a text file, called insert_authors.sql, containing an SQL insert statement to insert into your MySQL table author all the authors in authors.csv. The script passes to mysql the command to execute insert_authors.sql.

import sys
import csv
import re


def main():
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    with open(input_file, 'r') as csv_file:
        reader = csv.reader(csv_file)
        header = next(reader)
        insert_lines = []
      
        for row in reader:
            email = row[0]
            fname = row[1]
            lname = row[2]
            insert_query = f"INSERT INTO author (lname, fname, email) VALUES ('{lname}', '{fname}', '{email}');"
            insert_lines.append(insert_query)

        with open(output_file, 'w') as sql_file:
            content = '\n'.join(insert_lines)
            sql_file.write(content)

    print(f"SQL insert statements generated and saved to {output_file}.")


if __name__ == '__main__':
    main()
