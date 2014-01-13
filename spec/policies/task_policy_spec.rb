require 'spec_helper'

describe TaskPolicy do

  let(:owner) { create(:user) }
  let(:non_owner) { create(:user, username: 'jane') }
  let(:task) { create(:task_with_owner, user: owner) }

  context "for the task owner" do
    subject { TaskPolicy.new(owner, task) }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should_not permit(:destroy) }
  end
  
  context "for a task non-owner" do
    subject { TaskPolicy.new(non_owner, task) }

    it { should permit(:create) }
    it { should permit(:new) }
    it { should_not permit(:show) }
    it { should_not permit(:update) }
    it { should_not permit(:edit) }
    it { should_not permit(:destroy) }
  end
end
