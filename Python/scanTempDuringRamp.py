import pandas as pd 
import sys, os
from enum import Enum

class ColumnNames(Enum):
	TableName = 0
	Channel_Start = 1
	Channel_End	= 2
	Channel_Center = 3
	ChannelPower = 4
	Status = 5
	Temp = 6

class ChannelSeries:

	def __init__(self):
		self.ChannelCenter = 0
		self.ChannelPower = list()
		self.Temperatures = list()
		self.Count = 0

def isNumber(number):
	try:
		float(number)
		return True
	except Exception as e:
		print(e)
		return False

if __name__ == "__main__":
   
	filepath = r"C:\Users\lan68400\OneDrive - Lumentum Operations LLC\OCM\OCM ODVT Data\25\1-01551 1234 debug 20190826175205 1-1 ScanDuringRampTest.xlsx" #sys.argv[1]
	print(filepath)
	worksheetDataFrame = pd.read_excel(filepath, sheet_name="Raw Data Sheet")
	Tables = dict()
	ChannelData = dict()

	print("Creating DataFrames for each table")
	for index, row in worksheetDataFrame.iterrows():
		tableName = row[ColumnNames.TableName.name]
		if tableName not in list(Tables.keys()):
			Tables[tableName] = pd.DataFrame(columns=[col.name for col in ColumnNames])


		if isNumber(row[ColumnNames.Channel_Center.name]):
			Tables[tableName].loc[len(Tables[tableName])] = \
			{	
				ColumnNames.TableName.name:     tableName,
				ColumnNames.Channel_Start.name: row[ColumnNames.Channel_Start.name], 
				ColumnNames.Channel_End.name:   row[ColumnNames.Channel_End.name], 
				ColumnNames.Channel_Center.name:row[ColumnNames.Channel_Center.name], 
				ColumnNames.ChannelPower.name:  row[ColumnNames.ChannelPower.name],
				ColumnNames.Temp.name:      row[ColumnNames.Temp.name],
				ColumnNames.Status.name:    row[ColumnNames.Status.name]
			}

	print("Creating channel Series")	
	for tableName, dataTable in Tables.items():
		
		for index, row in dataTable.iterrows():
			
			rowChannelCenter = row[ColumnNames.Channel_Center.name]
			if (float(rowChannelCenter)) not in list(ChannelData.keys()):
				chSeries = ChannelSeries()
				chSeries.ChannelCenter = rowChannelCenter
				chSeries.ChannelPower.append(row[ColumnNames.ChannelPower.name])
				chSeries.Temperatures.append(row[ColumnNames.Temp.name])
				chSeries.Count += 1
				ChannelData[rowChannelCenter] = chSeries
				
			else:
				chSeries = ChannelData[rowChannelCenter]
				chSeries.ChannelPower.append(row[ColumnNames.ChannelPower.name])
				chSeries.Temperatures.append(row[ColumnNames.Temp.name])
				chSeries.Count += 1

	sys.exit()
	print("Done")




		   

		


           