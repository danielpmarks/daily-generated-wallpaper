import requests
import json
from openai import Client
import tempfile
import os
from datetime import datetime
import random
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv('API_KEY')
client = Client(api_key=api_key)

out_dir = os.getenv('DIRECTORY')

sample_prompts = [
    "A rainy day in Osaka with people walking around holding umbrellas, in the style of an anime cartoon"
    "A peaceful beautiful art deco featuring dense patterns of jungle plants and animals with bright vibrant colors",
    "A minimalist yet striking geometric design featuring intersecting lines and shapes in contrasting shades of monochrome. The composition exudes a sense of modernity and sophistication, perfect for a sleek and stylish desktop background.",
    "A beautiful Parisian street, filled with french architecture and busy citizens walking and sitting at cafes, pointilism",
    "A serene nature scene that encapsulates a calming Japanese garden teeming with life. The garden should have tranquil koi swimming leisurely in a pond, cherry blossoms blooming in all their glory, and gracefully arching bridges that add the perfect touch of elegance. The scene should be rendered with delicate lines and vibrant colors to create a harmonious and peaceful atmosphere. The visual interpretation should be aligned with the art of traditional Japanese woodblock prints, characterized by its simplicity, nuanced expression and abundant coloration."
    "A beautiful valley covered in lush forest. The air is slightly misty and the light is golden."
]

styles = [
    "watercolor",
    "grafiti",
    "photorealistic",
    "impressionist",
    "Van Gogh",
    "surrealism",
    "cubism",
    "art deco",
    "anime",
    "abstract",
    "pointilism",
    "origami",
    "comic book",
]

topics = [
    "food",
    "urbanism",
    "transit",
    "outer space",
    "mountains",
    "ocean",
    "nature",
    "society",
    "commerce",
    "technology",
    "culture",
    "music",
    "food",
    "famous landmarks",
    "nightlife",
    "architecture",
    "animals",
    "unique ecosystems"
]


def generate_prompt():
    prompts = [{"role": "user", "content": prompt} for prompt in sample_prompts]
    style = random.choice(styles)
    topic = random.choice(topics)
    thread=[
            {"role": "system", "content": """You are a prompt engineer trying to generate an image generation prompts for dense, 
            interesting pieces of art. Provide lots of details about the subject of your piece and emphasize artistic elements.
            """},
            {"role": "user", "content": "I want you to help me generate a new image generation prompt based on the following samples: "},
    ]+ prompts + [
        {"role": "user", "content": f"""Generate your own prompt for a beautiful image with a great deal of detail. 
        Be creative and try to create new images that are not similar to my samples, though its ok if they overlap.
        Your prompt should be based on the style of {style} and should feature {topic}. Make sure to mention that the style is {style}. Use a maximum of 40 words.
        """}
    ]
    
    response = client.chat.completions.create(
        model="gpt-4",
        messages=thread,
        top_p=0.9,
        temperature=1
    )
    
    return response.choices[0].message.content

def generate_image(prompt, model="dall-e-3", num_images=1, resolution='1792x1024'):
    response = client.images.generate(
        model=model,
        prompt=prompt,
        size=resolution,
        quality="hd",
        n=num_images,
    )
    return {"prompt": response.data[0].revised_prompt,"url": response.data[0].url}

def save_wallpaper(prompt, url):
     # Download the image from the URL
    response = requests.get(url)
    if response.status_code == 200:
        # Save the image to a temporary file
        temp_file = tempfile.NamedTemporaryFile(delete=False)
        temp_file.write(response.content)
        temp_file.close()
        # Get the current date and time
        current_datetime = datetime.now()
        
        # Generate a filename using the current date and time
        dirname = "Wallpaper_" + current_datetime.strftime("%Y-%m-%d")
        generate_dir = out_dir + "generated/" + dirname
        os.mkdir(generate_dir)
        # Save the image to the generated filename
        with open(generate_dir + "/wallpaper.png", "wb") as file:
            file.write(response.content)
        
        # Open the file in write mode, creating it if it doesn't exist
        with open(generate_dir + "/wallpaper_prompt.txt", "w") as file:
            # Write the prompt to the file
            file.write(prompt)
        
        return generate_dir + "/wallpaper.png"

if __name__ == "__main__":
    # Call the function to generate image
    prompt = generate_prompt()
    response = generate_image(prompt)

    print(save_wallpaper(response['prompt'], response['url']))



