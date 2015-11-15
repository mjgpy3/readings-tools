#!/usr/bin/env python

from sys import argv
from urllib2 import urlopen
from urlparse import urlparse
import json

import os, errno

def mkdir_p(path):
  try:
    os.makedirs(path)
  except OSError as exc:
    if exc.errno == errno.EEXIST and os.path.isdir(path):
      pass
    else: raise

errors = []

if __name__ == '__main__':
  if len(argv) < 3:
    print 'Usage: ./download.py <read-list-path> <output-path>'
    exit()

  file_path, output_path = argv[1], argv[2]

  with open(file_path, 'r') as f:
    obj = json.load(f)

  for article in obj['articles']:
    try:
      content = urlopen(article['url']).read()
      url = urlparse(article['url'])
      path = output_path + url.hostname.replace('.', '_') + '/'

      if path.startswith('_'):
          path = path[1:]

      mkdir_p(path)

      filename = path + url.path.replace('/', '_')

      if not filename.endswith('.html') and not filename.endswith('.html'):
        filename = filename + '.html'

      with open(filename, 'w') as f:
        f.write(content)
    except Exception as e:
      errors.append({ 'article': article, 'error': str(e) })

    'urlparse.urlparse("https://www.google.com").hostname'

  with open(output_path + 'errors.json', 'w') as f:
    f.write(json.dumps(errors))
