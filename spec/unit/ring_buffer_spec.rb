require 'rails_helper'

describe RingBuffer do
  describe '#push' do
    let(:ring_buffer) { RingBuffer.new(2) }

    context 'with element limit not reached' do
      before {
        ring_buffer.push('foo')
        ring_buffer.push('bar')
      }

      it 'pushes and keeps all elements' do
        expect(ring_buffer.to_a).to eq ['foo', 'bar']
      end
    end

    context 'with element limit reached' do
      before {
        ring_buffer.push('foo')
        ring_buffer.push('bar')
        ring_buffer.push('baz')
      }

      it 'pushes new element, popping out the first one (FIFO)' do
        expect(ring_buffer.to_a).to eq ['bar', 'baz']
      end
    end
  end

  describe '#full?' do
    let(:ring_buffer) { RingBuffer.new(1) }

    context 'element limit reached' do
      before { ring_buffer.push('foo') }

      it 'returns true' do
        expect(ring_buffer).to be_full
      end
    end

    context 'element limit not reached' do
      it 'returns false' do
        expect(ring_buffer).not_to be_full
      end
    end
  end
end
