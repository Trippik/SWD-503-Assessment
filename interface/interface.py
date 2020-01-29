import numpy as np
import pandas as pd

class simulator():

    def __create_grid(self, columns, rows):
        grid = pd.DataFrame(index=np.arange(rows), columns=np.arange(columns))
        value = 0
        counterx = 0
        countery = 0
        while (countery != rows):
            while (counterx != columns):
                grid.xs(countery)[counterx] = value
                counterx = counterx + 1
            else:
                countery = countery + 1
                counterx = 0
        else:
            return(grid)
    
    def __set_cell_status(self, grid, columns, rows):
        print(grid)
        loop = 1
        while (loop == 1):
            print("Please enter the x coordinate of the cell you would like to set to alive")
            x = int(input())
            print("Please enter the y coordinate of the cell you would like to set to alive")
            y = int(input())
            grid.xs(y)[x] = 1
            print()
            print("Would you like to alter any other cells (y/n)?")
            user_input = input()
            if (user_input == "y"):
                loop = 1
                print(grid)
            elif (user_input == "n"):
                loop = 0
        else:
            return(grid)

    def __simulation(self, grid, columns, rows):
        print("How many cycles do you wish to complete?")
        cycles = int(input())
        cycle_counter = 1
        while (cycle_counter != cycles):
            counterx = 0
            countery = 0
            while (countery != rows):
                while (counterx != columns):
                    value = grid.iloc[int(countery), int(counterx)]
                    if (value == 0):
                        value1 = 0
                        value2 = 0
                        value3 = 0
                        value4 = 0
                        counter_y_plus = int(countery + 1)
                        counter_y_minus = int(countery - 1)
                        counter_x_plus = int(counterx + 1)
                        counter_x_minus = int(counterx - 1)
                        try:
                            value1 = grid.iloc[int(counter_y_minus), int(counterx)]
                        except:
                            pass
                        try: 
                            value2 = grid.iloc[int(counter_y_plus), int(counterx)]
                        except:
                            pass
                        try:
                            value3 = grid.iloc[int(countery), int(counter_x_minus)]
                        except:
                            pass
                        try:
                            value4 = grid.iloc[int(countery), int(counter_x_plus)]
                        except:
                            pass
                    
                        combine = (value1 + value2 + value3 + value4)
                    
                        if (combine > 2):
                            print("x: " + str(counterx) + " y: " + str(countery) + " IT'S LIFE JIM")
                        else:
                            print("x: " + str(counterx) + " y: " + str(countery) + " :(")
                    counterx = counterx + 1
            else:
                countery = countery + 1
                counterx = 0
        else:
            print()
            print()
            print("Grid state at the end of cycle " + str(cycle_counter))
            print()
            print(grid)


    def run (self):
        print("How many columns would you like your grid to have")
        columns = int(input())
        print()
        print("How many rows would you like your grid to have")
        rows = int(input())
        self.grid = self.__create_grid(columns, rows)
        self.grid = self.__set_cell_status(self.grid, columns, rows)
        self.__simulation(self.grid, columns, rows)


grid1 = simulator()
grid1.run()
