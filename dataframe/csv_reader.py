import csv
import math

# texts that are treated as missing values
MISSING = ["", "NA", "NaN", "nan", "."]


class DataFrame:
    def __init__(self):
        self.nrow = 0
        self.ncol = 0
        self.names = []
        self.types = []
        self.index = []      
        self.numeric = []
        self.factors = []
        self.row_names = []
        self.bad_rows = 0


def is_missing(value):
    return value.strip() in MISSING


def is_number(value):
    if is_missing(value):
        return True

    try:
        float(value)
        return True
    except ValueError:
        return False


def make_factor(values):
    levels = sorted(set(v.strip() for v in values if not is_missing(v)))
    lookup = {level: i + 1 for i, level in enumerate(levels)}
    codes = []

    for value in values:
        if is_missing(value):
            codes.append(0)
        else:
            codes.append(lookup[value.strip()])

    return codes, levels


def read_csv(filename, separator=None):
    df = DataFrame()

    with open(filename, "r", encoding="utf-8") as file:
        text = file.read()

    # detect the separator: tab if the header contains a tab, else comma
    if separator is None:
        first_line = text.split("\n", 1)[0]
        separator = "\t" if "\t" in first_line else ","

    rows = list(csv.reader(text.splitlines(), delimiter=separator))

    if not rows:
        return df

    df.names = [name.strip() for name in rows[0]]
    data = [row for row in rows[1:] if any(field.strip() for field in row)]

    # Check whether the file has row names (one field more than the header)
    if data and len(data[0]) == len(df.names) + 1:
        df.row_names = [row[0] for row in data]
        data = [row[1:] for row in data]

    ncol = len(df.names)
    for i in range(len(data)):
        if len(data[i]) != ncol:
            df.bad_rows += 1
            data[i] = (data[i] + ["NA"] * ncol)[:ncol]

    if df.bad_rows > 0:
        print("Warning:", df.bad_rows, "row(s) with wrong number of fields")

    df.nrow = len(data)
    df.ncol = ncol

    if not data:
        return df

    columns = list(zip(*data))

    for name, values in zip(df.names, columns):

        values = list(values)

        if all(is_number(value) for value in values):
            numbers = []

            for value in values:
                if is_missing(value):
                    numbers.append(math.nan)
                else:
                    numbers.append(float(value))

            df.index.append(len(df.numeric))
            df.numeric.append({
                "name": name,
                "values": numbers
            })

            df.types.append("numeric")

        else:
            codes, levels = make_factor(values)

            df.index.append(len(df.factors))
            df.factors.append({
                "name": name,
                "codes": codes,
                "levels": levels
            })

            df.types.append("factor")

    return df


def get_column(df, name):
    # find a column by its name, using types and index
    j = df.names.index(name)
    if df.types[j] == "numeric":
        return df.numeric[df.index[j]]
    else:
        return df.factors[df.index[j]]


def numeric_matrix(df):
    # all numeric columns as a list of rows, for example for correlations
    names = [column["name"] for column in df.numeric]
    matrix = [[column["values"][i] for column in df.numeric]
              for i in range(df.nrow)]
    return names, matrix


def summary(df):
    # short summary of every column, similar to summary() in R
    for name, kind in zip(df.names, df.types):
        column = get_column(df, name)

        if kind == "numeric":
            values = [v for v in column["values"] if not math.isnan(v)]
            missing = df.nrow - len(values)
            if not values:
                print(f"{name:8} numeric  only missing values  NA {missing}")
                continue
            print(f"{name:8} numeric  min {min(values):7.1f}  "
                  f"mean {sum(values) / len(values):7.1f}  "
                  f"max {max(values):7.1f}  NA {missing}")
        else:
            counts = [column["codes"].count(k + 1)
                      for k in range(len(column["levels"]))]
            missing = column["codes"].count(0)
            levels = "  ".join(f"{level}: {count}" for level, count
                               in zip(column["levels"], counts))
            print(f"{name:8} factor   {levels}  NA {missing}")


def aggregate(df, value, group, func="mean"):
    # like R: aggregate(value ~ group, data=df, FUN=mean)
    values = get_column(df, value)["values"]
    factor = get_column(df, group)
    result = {}
    for code, level in enumerate(factor["levels"], start=1):
        group_values = [v for v, c in zip(values, factor["codes"])
                        if c == code and not math.isnan(v)]
        if not group_values:
            result[level] = math.nan
        elif func == "mean":
            result[level] = sum(group_values) / len(group_values)
        elif func == "min":
            result[level] = min(group_values)
        elif func == "max":
            result[level] = max(group_values)
        elif func == "count":
            result[level] = len(group_values)
    return result


def print_dataframe(df):
    print("Rows:", df.nrow)
    print("Columns:", df.ncol)

    print("\nColumn types:")

    for name, kind in zip(df.names, df.types):
        print(name, ":", kind)

    print("\nNumeric columns:")

    for column in df.numeric:
        print(column["name"], column["values"][:5])

    print("\nFactor columns:")

    for column in df.factors:
        print(column["name"])
        print("Levels:", column["levels"])
        print("Codes:", column["codes"][:5])


if __name__ == "__main__":
    import sys

    # file name from the command line, survey file as default
    filename = sys.argv[1] if len(sys.argv) > 1 else "survey-2021-11.tab.txt"

    df = read_csv(filename)
    print_dataframe(df)

    print("\nSummary:")
    summary(df)

    # examples for the survey dataset
    if filename == "survey-2021-11.tab.txt":
        print("\nMean height by gender:")
        print(aggregate(df, "cm", "gender"))

        print("\nMean weight by smoker:")
        print(aggregate(df, "kg", "smoker"))