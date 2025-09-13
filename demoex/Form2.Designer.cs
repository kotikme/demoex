
namespace demoex
{
    partial class Form2
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.dataGridViewApplications = new System.Windows.Forms.DataGridView();
            this.textBoxExpression = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.labelResult = new System.Windows.Forms.Label();
            this.buttonCalculate = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewApplications)).BeginInit();
            this.SuspendLayout();
            // 
            // dataGridViewApplications
            // 
            this.dataGridViewApplications.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewApplications.Location = new System.Drawing.Point(265, 25);
            this.dataGridViewApplications.Name = "dataGridViewApplications";
            this.dataGridViewApplications.RowTemplate.Height = 25;
            this.dataGridViewApplications.Size = new System.Drawing.Size(240, 150);
            this.dataGridViewApplications.TabIndex = 0;
            // 
            // textBoxExpression
            // 
            this.textBoxExpression.Location = new System.Drawing.Point(316, 181);
            this.textBoxExpression.Name = "textBoxExpression";
            this.textBoxExpression.Size = new System.Drawing.Size(100, 23);
            this.textBoxExpression.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(422, 184);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(15, 15);
            this.label1.TabIndex = 2;
            this.label1.Text = "=";
            // 
            // labelResult
            // 
            this.labelResult.AutoSize = true;
            this.labelResult.Location = new System.Drawing.Point(443, 184);
            this.labelResult.Name = "labelResult";
            this.labelResult.Size = new System.Drawing.Size(13, 15);
            this.labelResult.TabIndex = 3;
            this.labelResult.Text = "0";
            // 
            // buttonCalculate
            // 
            this.buttonCalculate.Location = new System.Drawing.Point(353, 210);
            this.buttonCalculate.Name = "buttonCalculate";
            this.buttonCalculate.Size = new System.Drawing.Size(75, 23);
            this.buttonCalculate.TabIndex = 4;
            this.buttonCalculate.Text = "Посчитать";
            this.buttonCalculate.UseVisualStyleBackColor = true;
            this.buttonCalculate.Click += new System.EventHandler(this.buttonCalculate_Click);
            // 
            // Form2
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.buttonCalculate);
            this.Controls.Add(this.labelResult);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBoxExpression);
            this.Controls.Add(this.dataGridViewApplications);
            this.Name = "Form2";
            this.Text = "Form2";
            this.Load += new System.EventHandler(this.Form2_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewApplications)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridViewApplications;
        private System.Windows.Forms.TextBox textBoxExpression;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label labelResult;
        private System.Windows.Forms.Button buttonCalculate;
    }
}