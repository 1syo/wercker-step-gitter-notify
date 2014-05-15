# Gitter notify step

The step-gitter-notify is a plugin that notifies Gitter.  

## Options

* ``token``  (required) Your Gitter token
* ``on`` (optional) When should this step send a message. Possible values: always and failed.

## Example

```
deploy:
  after-steps:
    - 1syo/gitter-notify@0.0.1:
        token: YOUR_GITTER_TOKEN
```

## License

The MIT License (MIT)
