<html>
<head>
    <style type="text/css">

        table.status {
            margin: auto;
            border-width: 1px 1px 1px 1px;
            border-style: solid;
            border-color: black;
            font-size: 3em;
            text-align: center;
            font-family: sans-serif;
        }

        td.bad {
            background-color: red;
        }

        td.good {
            background-color: green;
        }



    </style>
</head>
<body>

<table style="width: 100%; height: 100%;">
  <tr>
     <td style="text-align: center; vertical-align: middle;">
        <table class="status">
        <tr><th>Is MySQL Running?</th></tr>
        <tr>
        <?php

            $link = @mysql_connect('localhost', 'root', '');
            if(!$link) {
                print '<td class="bad">No</td>';
            } else {
                print '<td class="good">Yes!</td>';
            } 

        ?>
        </tr>
        </table>
    </td>
  </tr>
</table>
</body>
