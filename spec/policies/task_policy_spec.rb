require 'spec_helper'

describe TaskPolicy do
  subject { TaskPolicy.new(owner, task) }

  let(:owner) { create(:user) }
  let(:task) { create(:task_with_owner, user: owner) }

  context "for the task owner" do
    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }
  end
end
