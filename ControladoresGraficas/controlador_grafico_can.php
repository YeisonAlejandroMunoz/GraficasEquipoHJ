<?php
    require '../Modelo/modelo_grafico.php';

    $MG = new Modelo_Grafico();
    $consulta = $MG -> TraerDatosGraficoCant();
    echo json_encode($consulta);
?>