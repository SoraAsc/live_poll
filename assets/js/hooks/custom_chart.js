import { Chart, registerables } from 'chart.js'
Chart.register(...registerables)

export const CustomChart = {
    mounted() {
        this.createChart()
    },

    updated() {
        this.updateChart()
    },

    createChart() {
        let ctx = this.el.getContext('2d')
        const type = this.el.getAttribute('data-type') || 'bar'
        const label = this.el.getAttribute('data-label') || 'Poll'
        const labels = JSON.parse(this.el.getAttribute('data-labels')) || ["Poll"]
        const data = JSON.parse(this.el.getAttribute('data-dataset')) || [0]
        this.chart = new Chart(ctx, {
            type,
            data: 
            {
                labels: labels,//['January', 'February', 'March', 'April', 'May', 'June', 'July'],
                datasets: [{
                  label: label,
                  data: data,
                  backgroundColor: 'rgba(75, 192, 192, 0.2)',
                  borderColor: 'rgba(75, 192, 192, 1)',
                  borderWidth: 1
                }]
            },
            options: 
            {
                scales: {
                  y: {
                    beginAtZero: true,
                    ticks: {precision: 0}
                  },
                },
                maintainAspectRatio: false,
                responsive: false,
            }
        })
    },

    updateChart() {
        const newDataset = JSON.parse(this.el.getAttribute('data-dataset')) || [0]
        this.chart.data.datasets[0].data = newDataset
        this.chart.update()
    }
}