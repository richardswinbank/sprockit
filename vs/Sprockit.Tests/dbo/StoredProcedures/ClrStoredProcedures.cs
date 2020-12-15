using Microsoft.SqlServer.Server;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;

namespace SprockitTests
{
    public partial class ClrStoredProcedures
    {
        [SqlProcedure]
        public static void SendResultsToTable(SqlString targetTableName, SqlString sqlStatement)
        {
            using (var connection = new SqlConnection("Context Connection=true;"))
            using (var adapter = new SqlDataAdapter($"SELECT TOP 0 * FROM {targetTableName.Value}", connection))
            using (var builder = new SqlCommandBuilder(adapter))
            using (var targetDataSet = new DataSet())
            {
                connection.Open();
                adapter.Fill(targetDataSet);
                var targetTable = targetDataSet.Tables[0];

                using (var cmd = new SqlCommand(sqlStatement.Value, connection))
                {
                    using (var dataReader = cmd.ExecuteReader(CommandBehavior.KeyInfo))
                    {
                        var schemaTable = dataReader.GetSchemaTable();
                        if (schemaTable == null)
                            return;

                        var availableColumns = new Dictionary<string, int>();
                        foreach (DataRow c in schemaTable.Rows)
                            availableColumns.Add((string)c["ColumnName"], (int)c["ColumnOrdinal"]);

                        var commonColumns = new Dictionary<DataColumn, int>();
                        foreach (DataColumn k in targetTable.Columns)
                        {
                            int index;
                            if (availableColumns.TryGetValue(k.ToString(), out index))
                                commonColumns.Add(k, index);
                        }

                        object[] recordData = new object[dataReader.FieldCount];
                        while (dataReader.Read())
                        {
                            dataReader.GetValues(recordData);

                            var row = targetTable.NewRow();
                            foreach (var kvp in commonColumns)
                                row[kvp.Key] = recordData[kvp.Value];
                            targetTable.Rows.Add(row);
                        }
                    }
                }

                adapter.Update(targetDataSet);
            }
        }
    }
}