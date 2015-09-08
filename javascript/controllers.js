/**
 * Created by Walter on 9/7/2015.
 */

var portfolio = angular.module("portfolio", ['ui.bootstrap']);

portfolio.directive('stockChart', function() {
    return {
        restrict: 'EA',
        scope: {
            ticker: '@',
            data: '='
        },
        link: function (scope, element) {
            var margin = {top: 20, right: 20, bottom: 30, left: 50};
            var width = element[0].getBoundingClientRect().width - margin.left - margin.right;
            var height = element[0].getBoundingClientRect().height - margin.top - margin.bottom;

            var svg = d3.select(element[0]).append("svg")   // this needs to be fixed
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
            var parseDate = d3.time.format("%Y-%m-%d").parse;

            var x = techan.scale.financetime()
                .range([0, width])
                .outerPadding(0);

            var y = d3.scale.linear()
                .range([height, 0]);

            var close = techan.plot.close()
                .xScale(x)
                .yScale(y);

            var xAxis = d3.svg.axis()
                .scale(x)
                .orient("bottom");

            var yAxis = d3.svg.axis()
                .scale(y)
                .orient("left");
            var accessor = close.accessor();
            scope.$watch('data', function (newVal) {
                if (newVal) {
                    newVal.sort(function (a, b) {
                        return d3.ascending(accessor.d(a), accessor.d(b));
                    });
                    console.log("in directive");
                    console.log(techan.scale.plot.ohlc(newVal, accessor).domain());
                    x.domain(newVal.map(accessor.d));
                    y.domain(techan.scale.plot.ohlc(newVal, accessor).domain());

                    svg.append("g")
                        .datum(newVal)
                        .attr("class", "close")
                        .call(close);

                    svg.append("g")
                        .attr("class", "x axis")
                        .attr("transform", "translate(0," + height + ")")
                        .call(xAxis);

                    svg.append("g")
                        .attr("class", "y axis")
                        .call(yAxis)
                        .append("text")
                        .attr("transform", "rotate(-90)")
                        .attr("y", 6)
                        .attr("dy", ".71em")
                        .style("text-anchor", "end")
                        .text("Price ($)");
                }
            });
        }
    }
});

portfolio.controller("StockController", function($scope, $http){

    $scope.init_data = function() {
        /*var currentDate = new Date();
        var currentDateString = currentDate.getFullYear() + "-" + ("0" + (currentDate.getMonth() + 1)).slice(-2) + "-" + ("0" + currentDate.getDate()).slice(-2);
        var previousDate = new Date();
        var previousDate = new Date(previousDate.setMonth(currentDate.getMonth() - 3));
        var previousDateString = previousDate.getFullYear() + "-" + ("0" + (previousDate.getMonth() + 1)).slice(-2) + "-" + ("0" + previousDate.getDate()).slice(-2);

        var main = "http://www.quandl.com/api/v1/datasets/" + $scope.stock.dataset + ".json";
        var params = "?&trim_start=" + previousDateString + "&trim_end=" + currentDateString;
        var auth = "&auth_token=sok7xuv8xDR_9LooZmaZ";
        var url = main + params + auth;*/
        console.log("in the controller");
        var url = "https://agile-garden-2056.herokuapp.com/backtests";
        var portfolio_id = 1;
        var startDate = "2015-08-01";
        var endDate = "2015-08-31";
        var starting_amount = 100000;
        var backtest_params = { "backtest":
            {   "start_date": startDate,
                "end_date":endDate,
                "starting_amount": starting_amount,
                "portfolio_id": portfolio_id
            }};
        console.log(backtest_params);
        $http.post(url, backtest_params).success(function (response) {
            var parseDate = d3.time.format("%Y-%m-%d").parse;
            console.log(response);
            $scope.data = (Object.keys(response)).map(function (value, index) {
                return {
                    date: value,
                    open:response[value]['folio'],
                    high: response[value]['folio'],
                    low: response[value]['folio'],
                    close: response[value]['folio'],
                    volume: 0
                };
            });
            console.log($scope.data);
        });
    };
    $scope.init_data();
});
