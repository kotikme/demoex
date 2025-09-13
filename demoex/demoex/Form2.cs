using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;
namespace demoex
{
    public partial class Form2 : Form
    {
        string connectionString = "Host=127.0.0.1;Port=5432;Database=test;Username=postgres;Password=postgres";
        public Form2()
        {
            InitializeComponent();
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            try
            {
                using (NpgsqlConnection conn = new NpgsqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                SELECT 
                    a.id AS app_id, 
                    pr.name AS app_date, 
                    a.total_cost AS total_cost
                FROM app.applications a
                JOIN app.partners pr ON a.partner_id = pr.id
                ORDER BY a.date DESC"; // Сортировка по дате, чтобы новые сверху

                    NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    dataGridViewApplications.DataSource = dt; // Привязка к DataGridView
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка загрузки данных: " + ex.Message, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        private void buttonCalculate_Click(object sender, EventArgs e)
        {
            string expression = textBoxExpression.Text;

            try
            {
                // Используем DataTable.Compute для вычисления математического выражения
                var result = new DataTable().Compute(expression, null);
                labelResult.Text = result.ToString();
            }
            catch (Exception ex)
            {
                labelResult.Text = "Ошибка: неверное выражение";
            }
        }
    }
}
