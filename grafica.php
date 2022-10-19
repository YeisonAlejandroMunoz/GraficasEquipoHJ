<!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <title>GRAFICO</title>
</head>

<body>
    <div class="col-lg-12" style="padding-top: 20px;">
        <!--Canvas-->
        <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-4">
                        <h3>Reservas</h3>
                        <canvas id="graficopie" width="400" height="400"></canvas>
                    </div>
                    <div class="col-lg-4">
                        <h3>Cantidades reservadas</h3>
                        <canvas id="graficobarhorizontal" width="400" height="400"></canvas>
                    </div>
                    <div class="col-lg-4">
                        <h3>Ganancias totales</h3>
                        <canvas id="graficobar" width="400" height="400"></canvas>
                    </div>
                    <div class="col-lg-4">

                </div>
            </div>
        </div>
        <!--Canvas-->

        <br>

        <!--Apartado de busqueda-->
        <div class="card">
            <div class="card-header">Busqueda por Fecha</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-4">
                        <label for="">Fecha Inicio</label> <br>
                        <select name="" id="select_finicio" class="form-control"></select>
                    </div>
                    <div class="col-lg-4">
                        <label for="">Fecha Fin </label> <br>
                        <select name="" id="select_ffin" class="form-control"></select>
                    </div>
                    <div class="col-lg-2">
                        <label for="">&nbsp;</label> <br>
                        <button class="btn btn-danger" onclick="CargarDatosGraficaParametros()">Buscar</button>
                    </div>

                    <!--Canvas De Busqueda-->
                    <div class="col-lg-4">
                        <br>
                    <h3>Ventas de las reservas</h3>
                        <canvas id="bar_parametro" width="400" height="400"></canvas>
                    </div>
                    <div class="col-lg-4">
                    <br>
                    <h3>Cantidades reservadas</h3>
                        <canvas id="graficobarhorizontal_parametro" width="400" height="400"></canvas>
                    </div>
                    <div class="col-lg-4">
                    <br>
                    <h3>Ganancias del Año</h3>
                        <canvas id="doughnut_parametro" width="400" height="400"></canvas>
                    </div>
                    <!--Canvas De Busqueda-->
                </div>
            </div>
        </div>


    </div>

</body>

</html>



<!--  Script  Chart-->
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js"></script>
<!--  Script  Chart-->

<script>
    CargarDatosGraficaBar();
    CargarDatosGraficaBarHorizontal();
    CargarDatosGraficaPie();
    
    function CargarDatosGraficaPie() {
        $.ajax({
            url: './ControladoresGraficas/controlador_grafico_mas.php',
            type: 'POST'
        }).done(function(resp) {
            if (resp.length > 0) {
                var titulo = [];
                var cantidad = [];
                var data = JSON.parse(resp);
                for (var i = 0; i < data.length; i++) {
                    titulo.push(data[i][0]);
                    cantidad.push(data[i][1]);
                }
                CrearGrafico(titulo, cantidad, 'pie', 'Precio', 'graficopie');
            }
        })
    }

    function CargarDatosGraficaBarHorizontal() {
        $.ajax({
            url: './ControladoresGraficas/controlador_grafico_can.php',
            type: 'POST'
        }).done(function(resp) {
            if (resp.length > 0) {
                var titulo = [];
                var cantidad = [];
                var data = JSON.parse(resp);
                for (var i = 0; i < data.length; i++) {
                    titulo.push(data[i][0]);
                    cantidad.push(data[i][1]);
                }
                CrearGrafico(titulo, cantidad, 'horizontalBar', 'Unidades', 'graficobarhorizontal');
            }
        })
    }

    function CargarDatosGraficaBar() {
        $.ajax({
            url: './ControladoresGraficas/controlador_grafico.php',
            type: 'POST'
        }).done(function(resp) {
            if (resp.length > 0) {
                var titulo = [];
                var cantidad = [];
                var data = JSON.parse(resp);
                for (var i = 0; i < data.length; i++) {
                    titulo.push(data[i][0]);
                    cantidad.push(data[i][1]);
                }
                CrearGrafico(titulo, cantidad, 'bar', 'Ganancias', 'graficobar');
            }
        })
    }   


    //Busqueda Por Parametros//
    TraerYears();
    function CargarDatosGraficaParametros(){
        CargarDatosGraficaParametroDoughnut();
        CargarDatosGraficaParametroScatter();
        CargarDatosGraficaParametroBar();
    }
    function TraerYears(){
        var mifecha = new Date();
        var years = mifecha.getFullYear();
        var cadena ="";
        for (var i=2021; i < years+2;i++){
            cadena+="<option value="+i+">"+i+"</option>";
        }
        $("#select_finicio").html(cadena);
        $("#select_ffin").html(cadena);
    }

    function CargarDatosGraficaParametroBar() {
        var fechainicio = $("#select_finicio").val();
        var fechafin = $("#select_ffin").val();
        $.ajax({
            url: './BusquedaAño/controlador_grafico_ventas.php',
            type: 'POST',
            data:{
                inicio:fechainicio,
                fin:fechafin,
            }
        }).done(function(resp) {
            if (resp.length > 0) {
                var titulo = [];
                var cantidad = [];
                var data = JSON.parse(resp);
                for (var i = 0; i < data.length; i++) {
                    titulo.push(data[i][0]);
                    cantidad.push(data[i][1]);
                }
                CrearGrafico(titulo, cantidad, 'bar', 'Precio', 'bar_parametro');
            }
        })
    }

    function CargarDatosGraficaParametroDoughnut() {
        var fechainicio = $("#select_finicio").val();
        var fechafin = $("#select_ffin").val();
        $.ajax({
            url: './BusquedaAño/controlador_grafico_parametro.php',
            type: 'POST',
            data:{
                inicio:fechainicio,
                fin:fechafin,
            }
        }).done(function(resp) {
            if (resp.length > 0) {
                var titulo = [];
                var cantidad = [];
                var data = JSON.parse(resp);
                for (var i = 0; i < data.length; i++) {
                    titulo.push(data[i][0]);
                    cantidad.push(data[i][1]);
                }
                CrearGrafico(titulo, cantidad, 'doughnut', 'Precio', 'graficobarhorizontal_parametro');
            }
        })
    }

    function CargarDatosGraficaParametroScatter() {
        var fechainicio = $("#select_finicio").val();
        var fechafin = $("#select_ffin").val();
        $.ajax({
            url: './BusquedaAño/controlador_grafico_ganancias.php',
            type: 'POST',
            data:{
                inicio:fechainicio,
                fin:fechafin,
            }
        }).done(function(resp) {
            if (resp.length > 0) {
                var titulo = [];
                var cantidad = [];
                var data = JSON.parse(resp);
                for (var i = 0; i < data.length; i++) {
                    titulo.push(data[i][0]);
                    cantidad.push(data[i][1]);
                }
                CrearGrafico(titulo, cantidad, 'polarArea', 'Precio', 'doughnut_parametro');
            }
        })
    }


    function CrearGrafico(titulo, cantidad, tipo, emcabezado, id) {
        const ctx = document.getElementById(id);
        const myChart = new Chart(ctx, {
            type: tipo,
            data: {
                labels: titulo,
                datasets: [{
                    label: emcabezado,
                    data: cantidad,
                    backgroundColor: [
                        'rgba(205, 13, 231, 0.2)',
                        'rgba(231, 122, 13, 0.2)',
                        'rgba(49, 13, 231, 0.2)',
                        'rgba(13, 231, 17, 0.2)',
                    ],
                    borderColor: [
                        'rgba(205, 13, 231)',
                        'rgba(231, 122, 13)',
                        'rgba(49, 13, 231)',
                        'rgba(13, 231, 17)',

                    ],
                    borderWidth: 1,
                }]
            },
            options: {
                locale: 'en-CO',
                scales: {
                    yAxes: [{
                        ticks:{
                            callback: (value, index, values) =>{
                                return new Intl.NumberFormat('en-CO', {
                                    style: 'currency',
                                    currency: 'COP',
                                    maximumSignificantDigits: 3 
                                    }).format(value);
                                },
                            precision: 0,
                            beginAtZero: true,
                        }
                    }],
                    xAxes: [{
                        ticks:{
                            beginAtZero: true
                        }
                    }], 
                }
            }
        });
        
    }   
</script>