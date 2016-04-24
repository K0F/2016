#ifndef _MAIN_H
#define _MAIN_H

#include <jack/types.h>
#include <jack/ringbuffer.h>

typedef jack_default_audio_sample_t sample_t;

void audio_init(const char *name, const char * const * connect_ports);
void audio_adjust();

const char * audio_get_client_name();
jack_nframes_t audio_get_samplerate();

jack_nframes_t audio_buffer_get_available();
void audio_buffer_read(int nport, sample_t *frames, jack_nframes_t nframes);

#endif // _MAIN_H
