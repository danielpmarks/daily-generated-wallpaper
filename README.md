# daily-generated-wallpaper

This program uses OpenAI's models to generate a custom wallpaper daily. By utilizing both Dall-E-3 and GPT-4, the program generates a detailed prompt for an image that will be visually interesting based on some baseline guidance, which is generated into an image and set the desktop wallpaper. It is important to understand that this program is NOT free. It requires an OpenAI account with purchased API credits; however, the program should cost less than $0.15 a day, or around $4.50 a month. For this reason, it is recommended to set up automatic billing with OpenAI via https://platform.openai.com/account/billing/overview

### Setup
Clone this repository into a directory on your Mac. Navigate to the directory in the command line and run the setup script:

```
% ./setup.sh
```
Navigate to the [OpenAI API key manager](https://platform.openai.com/api-keys). Copy your secret key, and enter it when prompted:
```
Please enter your OpenAI API key: <YOUR_API_KEY>
```
Accept the prompt to allow permissions.

<img width="265" alt="Screenshot 2024-03-19 at 11 09 15 PM" src="https://github.com/danielpmarks/daily-generated-wallpaper/assets/35392192/dd71872f-893f-4e2e-922c-827801145a57">

Next, you will be prompted to open System Preferences. Make usre that cron has permission for System Events. [Cron](https://en.wikipedia.org/wiki/Cron") is a Unix-based automation tool, and is used to schedule the job which sets the wallpaper automatically.

<img width="483" alt="Screenshot 2024-03-19 at 11 13 17 PM" src="https://github.com/danielpmarks/daily-generated-wallpaper/assets/35392192/cff7f4d2-5982-4461-94f6-093da16fac16">

After running the setup script, your user's crontab will contain instructions to run the generate.sh script every 5 minutes. Rest assured, this will _not_ generate a new image every time it's run, since the script checks whether it's been run already that day. Only once the date changes will the program actually make requests to the OpenAI API, ensuring you will not be over charged for erroneous requests.
