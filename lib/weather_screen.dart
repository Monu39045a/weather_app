import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_information.dart';
import 'package:weather_app/hourly_weather_forecast_item.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/secret_file.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = "Delhi";
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey");
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      if (data['cod'] != '200') {
        throw data['messgae'];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: MainAxisAlignment.center
      appBar: AppBar(
        toolbarHeight: 100,
        titleSpacing: 10,
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      // body: temp == 0
      //     ? const CircularProgressIndicator()
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
              ),
            );
          }

          // getting data from API , ! => so that it is nullable
          final data = snapshot.data!;

          final currentMainPath = data['list'][0];

          final currentTemp = currentMainPath['main']['temp'];
          final currentSky = currentMainPath['weather'][0]['main'];

          final currentPressure =
              currentMainPath['main']['pressure'].toString();
          final currentHumidity =
              currentMainPath['main']['humidity'].toString();
          final currentWindSpeed = currentMainPath['wind']['speed'].toString();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    //The card property don't take the max width for that we need to wrap it around the container widget or sizedBox as we only need width we go with sizedBox and set width
                    // elevation:
                    //     0, // By default card has some elevation if we don't want that set ot to 0
                    elevation: 10,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32),
                              ),
                              const SizedBox(height: 20),
                              Icon(
                                currentSky == "Clouds" || currentSky == "Rain"
                                    ? Icons.cloud
                                    : Icons.wb_sunny_rounded,
                                size: 80,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 10),
                //Weather forecast cards

                SizedBox(
                  height: 130,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky =
                            data['list'][index + 1]['weather'][0]['main'];
                        final time =
                            DateTime.parse(hourlyForecast['dt_txt'].toString());
                        return HourlyForecastItem(
                          temperature:
                              hourlyForecast['main']['temp'].toString(),
                          icon: hourlySky == "Clouds" || hourlySky == "Rain"
                              ? Icons.cloud
                              : Icons.wb_sunny,
                          time: DateFormat.Hm().format(time),
                        );
                      }),
                ),
                const SizedBox(height: 20),
                // Additional Information
                const Text(
                  "Additional Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop_outlined,
                      label: "Humidity",
                      value: currentHumidity,
                    ),
                    AdditionalInformation(
                      icon: Icons.air_sharp,
                      label: "Wind Speed",
                      value: currentWindSpeed,
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: currentPressure,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// OLD STUFFS

// Border radius
// shape: OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(
                    //     Radius.circular(30),
                    //   ),


// with the help of chatgpt
// Future getCurrentWeather() async {
//   String cityName = "London";
//   final url = Uri.parse(
//       "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey");
//   try {
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       print(response.body);
//     } else {
//       // If the server returns an error response, throw an exception
//       throw Exception('Failed to load weather data');
//     }
//   } catch (e) {
//     // Catch any error that might occur during the process
//     print('Error fetching weather data: $e');
//     throw Exception('Failed to load weather data');
//   }
// }



// Applied for loop in place of this 
// HourlyForecastItem(
                      //   time: "03:00",
                      //   temperature: "300.60K",
                      //   icon: Icons.cloud,
                      // ),
                      // HourlyForecastItem(
                      //     time: "06:00",
                      //     temperature: "312.6K",
                      //     icon: Icons.cloud),
                      // HourlyForecastItem(
                      //   time: "09:00",
                      //   temperature: "320.5K",
                      //   icon: Icons.sunny,
                      // ),
                      // HourlyForecastItem(
                      //   time: "12:00",
                      //   temperature: "337.90K",
                      //   icon: Icons.sunny,
                      // ),
                      // HourlyForecastItem(
                      //   time: "15:00",
                      //   temperature: "323K",
                      //   icon: Icons.thunderstorm,
                      // ),


// LAZY LOADING IMPLEMENTED IN PLACE OF THIS
// SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 1; i < 40; ++i)
                //         // final hourlyTemp = data['list'][i];
                //         HourlyForecastItem(
                //           time: data['list'][i]['dt'].toString(),
                //           temperature:
                //               data['list'][i]['main']['temp'].toString(),
                //           icon: data['list'][i]['weather'][0]['main'] ==
                //                       "Clouds" ||
                //                   data['list'][i]['weather'][0]['main'] ==
                //                       "Rain"
                //               ? Icons.cloud
                //               : Icons.wb_sunny,
                //         ),
                //     ],
                //   ),
                // ),